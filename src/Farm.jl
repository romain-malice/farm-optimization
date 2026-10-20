using JuMP
import HiGHS
#using Gurobi
using CSV
using DataFrames

src_dir = @__DIR__
data_dir = normpath(joinpath(src_dir, "..", "data"))

# ---------------------------
# | Get data from csv files |
# ---------------------------

param_df = CSV.read(joinpath(data_dir, "parameters.csv"), DataFrame)
param = Dict(
    Symbol(row.parameter) => row.value
    for row in eachrow(param_df)
) # Call with param[:xxx]


blocks_df = CSV.read(joinpath(data_dir, "blocks.csv"), DataFrame)
blocks_set = blocks_df.block

crops_df = CSV.read(joinpath(data_dir, "crops.csv"), DataFrame)
crops_set = crops_df.crop

init_areas_df = CSV.read(joinpath(data_dir, "initial_areas.csv"), DataFrame)
labour_df = CSV.read(joinpath(data_dir, "labour.csv"), DataFrame)
markets_df = CSV.read(joinpath(data_dir, "markets.csv"), DataFrame)
parameters_df = CSV.read(joinpath(data_dir, "parameters.csv"), DataFrame)

water_df = CSV.read(joinpath(data_dir, "water.csv"), DataFrame)
periods_set = water_df.period

yields_df = CSV.read(joinpath(data_dir, "yields.csv"), DataFrame)
calendar_df = CSV.read(joinpath(data_dir, "calendar.csv"), DataFrame)

# ---------
# | Utils |
# ---------

function df_get_elmt(df, row_str, col_row_str, col_val)
    row_idx = findfirst(==(row_str), df[!, col_row_str])
    return df[row_idx, col_val]
end

function get_yield(crop, soil)
    return only(yields_df[
        (yields_df[!, "crop"] .== crop) .& (yields_df[!, "soil_class"] .== soil), "yield_t_per_ha"
    ])
end

function get_soil(block)
    return df_get_elmt(blocks_df, block, "block", "soil_class")
end

FARM_AREA = sum(blocks_df[:, :area_ha])

# ---------
# | Model |
# ---------

model = Model(HiGHS.Optimizer)

# VARIABLES
# ----------

# share of land of each crop, on each block
@variable(model, share_ha[blocks_set, crops_set] >= 0)

# CONSTRAINTS
# ------------

# Land
# -----

# Correct area usage
@constraint(model,
    [b in blocks_set],
    sum(share_ha[b, c] for c in crops_set) == df_get_elmt(blocks_df, b, "block", "area_ha"))

# Maximum shares are respected
@constraint(model,
    [c in crops_set],
    sum(share_ha[b, c] for b in blocks_set) <= FARM_AREA * df_get_elmt(crops_df, c, "crop", "max_farm_share"))

# Minimum non productive area
@constraint(model, sum(share_ha[:, "cover_fallow"]) >= param[:non_productive_share])

# Benefits
# ---------

# Yield of each crop (tons)
@expression(model,
    yield_t[c in crops_set], sum([share_ha[b, c] * get_yield(c, get_soil(b)) for b in blocks_set]))

# Benefit from sugar beet

contract_min_t = df_get_elmt(markets_df, "sugar_beet", "crop", "contract_min_t")
contract_max_t = df_get_elmt(markets_df, "sugar_beet", "crop", "contract_max_t")
price_EUR_per_t = df_get_elmt(markets_df, "sugar_beet", "crop", "price_EUR_per_t")
spot_price_EUR_per_t = df_get_elmt(markets_df, "sugar_beet", "crop", "spot_price_EUR_per_t")

@variable(model, contract_min_t <= yield_contract_t <= contract_min_t)
@variable(model, yield_surplus_t >= 0)

@constraint(model, yield_t["sugar_beet"] == yield_contract_t + yield_surplus_t)

@expression(model, benefits_sb_EUR,
    yield_contract_t * price_EUR_per_t + yield_surplus_t * spot_price_EUR_per_t
)

# Total benefits

commercial_crops_set = [c for c in crops_set if c != "cover_fallow"]
@expression(model, benefits_EUR[c in commercial_crops_set],
    c == "sugar_beet" ?
    benefits_sb_EUR :
    yield_t[c] * df_get_elmt(markets_df, c, "crop", "price_EUR_per_t")
)

@expression(model, total_benefits_EUR, sum(benefits_EUR))

# Losses
# -------

# Wages (depend on period)

function get_labour(crop, period)
    return only(calendar_df[
        (calendar_df[!, "crop"] .== crop) .& (calendar_df[!, "period"] .== period), "labour_h_per_ha"
    ])
end

function get_irrigation(crop, period)
    return only(calendar_df[
        (calendar_df[!, "crop"] .== crop) .& (calendar_df[!, "period"] .== period), "irrigation_m3_per_ha"
    ])
end

# Number of hours needed to take care of the crops each period
@expression(
    model,
    work_h[p in periods_set],
    sum([get_labour(c, p) * sum(share_ha[:, c]) for c in crops_set])
)

# Work hours repartition
@variable(model, 0 <= family_h[p in periods_set] <= df_get_elmt(labour_df, p, "period", "family_hours"))
@variable(model, 0 <= hired_h[p in periods_set] <= df_get_elmt(labour_df, p, "period", "hired_hours_cap"))
@constraint(model, [p in periods_set], work_h[p] == family_h[p] + hired_h[p])

@expression(model, wages_EUR[p in periods_set],
    hired_h[p] * df_get_elmt(labour_df, p, "period", "hired_cost_EUR_per_h"))

# Water

function prev_period(p)
    return periods_set[findfirst(==(p), periods_set)-1]
end

# Water level at each stage
@variable(model, 0 <= water_level_end[periods_set] <= param[:reservoir_capacity]) # Needed for linearity
@variable(model, 0 <= water_level_start[periods_set] <= param[:reservoir_capacity])

@constraint(model, water_level_start[periods_set[1]] == param[:reservoir_initial])
@constraint(model, water_level_end[periods_set[end]] == param[:reservoir_terminal])
@constraint(model, [p in periods_set[2:end]],
    water_level_start[p] == water_level_end[prev_period(p)])

# Free inflow
@variable(model, 0 <= used_inflow_m3[p in periods_set] <= df_get_elmt(water_df, p, "period", "reservoir_inflow_m3"))

# Pumping
@variable(model, 0 <= pumped_m3[p in periods_set] <= df_get_elmt(water_df, p, "period", "pumping_cap_m3"))
@constraint(model, sum(pumped_m3) <= param[:abstraction_licence])

@expression(model, pumping_costs_EUR[p in periods_set], param[:pumping_cost] * sum(pumped_m3))

# Water needed for crops
@expression(model, water_needed_m3[p in periods_set],
    sum([get_irrigation(c, p) * sum(share_ha[:, c]) for c in crops_set]))

# Equilibrium
@constraint(model, [p in periods_set],
    water_level_end[p] == water_level_start[p] + used_inflow_m3[p] + pumped_m3[p] - water_needed_m3[p]
)

# Crops price

@expression(model, crop_costs_EUR,
    sum([df_get_elmt(crops_df, c, "crop", "variable_cost_EUR_per_ha") * sum(share_ha[:, c]) for c in crops_set])
)

# Total

@expression(model, total_losses_EUR, sum(wages_EUR) + sum(pumping_costs_EUR) + crop_costs_EUR)

# OBJECTIVE FN
# -------------

@objective(model, Max, total_benefits_EUR - total_losses_EUR)