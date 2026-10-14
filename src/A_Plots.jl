using Plots
using StatsPlots

out_dir = joinpath(src_dir, "..", "output")

# Solve farm model
include("Farm.jl")
optimize!(model)

if termination_status(model) == MOI.OPTIMAL
    println("Optimal solution found, the benefit is ", objective_value(model), " euros.")
else
    println("No optimal solution found")    
end

# Gross margin
println("1. Gross margin = ", objective_value(model), " euros")
println("   Benefits = ", value(total_benefits_EUR), " and losses = ", value(total_losses_EUR))
println("")

# Cropping plan
println("2. Distribution of crops...")

crop_p = bar(
    blocks_set,
    Array(value(share_ha)),
    bar_position = :stack,
    label = permutedims(crops_set),
    ylabel = "Share of Crop [ha]",
    xlabel = "Block Name"
)

savefig(crop_p, joinpath(out_dir, "crop_plan.svg"))

# Water use
t = range(0, length(periods_set))
water_level = push!(Array(value(water_level_start)), param[:reservoir_terminal])
water_p = plot(
    t, water_level,
    ylabel = "Volume [m3]",
    xlabel = "Period Index"
)

hline!([param[:reservoir_capacity] for i in t])

savefig(water_p, joinpath(out_dir, "water_use.svg"))

# Hired labour
hh = Array(value(hired_h))
hh_cap = [df_get_elmt(labour_df, p, "period", "hired_hours_cap") for p in periods_set]
fh = Array(value(family_h))
fh_cap = [df_get_elmt(labour_df, p, "period", "family_hours") for p in periods_set]
y = hcat(hh, hh_cap, fh, fh_cap)
hired_p = groupedbar(
    periods_set, y,
    bar_position = :dodge,
    label = permutedims(["Hired hours", "Max hired hours", "Family hours", "Max family hours"]),
    ylabel = "Hours of work",
    xlabel = "Periods"
)

savefig(hired_p, joinpath(out_dir, "work_hours.svg"))