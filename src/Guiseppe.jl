using CSV, DataFrames, JuMP, Gurobi, Printf

src_dir = @__DIR__
data_dir = normpath(joinpath(src_dir, "..", "data"))

blocks = DataFrame(CSV.File(joinpath(data_dir, "blocks.csv")))
crops  = DataFrame(CSV.File(joinpath(data_dir, "crops.csv")))
yields = DataFrame(CSV.File(joinpath(data_dir, "yields.csv")))
cal    = DataFrame(CSV.File(joinpath(data_dir, "calendar.csv")))
lab    = DataFrame(CSV.File(joinpath(data_dir, "labour.csv")))
wat    = DataFrame(CSV.File(joinpath(data_dir, "water.csv")))
mkt    = DataFrame(CSV.File(joinpath(data_dir, "markets.csv")))
par    = DataFrame(CSV.File(joinpath(data_dir, "parameters.csv")))

B = string.(col(blocks, "block", "id", "name"))
C = string.(col(crops, "crop", "name", "id"))
T = string.(col(lab, "period"))
nT = length(T)
fallow = C[findfirst(c -> occursin("fallow", lowercase(c)), C)]

area = Dict(zip(B, Float64.(col(blocks, "area"))))
soil = Dict(zip(B, string.(col(blocks, "soil"))))
farm_area = sum(values(area))


vcost = Dict(zip(C, Float64.(col(crops, "variable_cost", "cost"))))
dshare = Dict(zip(C, Float64.(col(crops, "max_farm_share", "diversification", "share"))))


Y = Dict{Tuple{String,String},Float64}()
for r in eachrow(yields)
    Y[(string(col(DataFrame(r), "crop")[1]), string(col(DataFrame(r), "soil")[1]))] =
        Float64(col(DataFrame(r), "yield")[1])
end


lreq = Dict((c, t) => 0.0 for c in C, t in T)
let cc = string.(col(cal, "crop")), pp = string.(col(cal, "period")),
    ww = col(cal, "water", "irrigation"), ll = col(cal, "labour", "labor", "hours")
    for i in eachindex(cc)
        wreq[(cc[i], pp[i])] = Float64(ww[i])
        lreq[(cc[i], pp[i])] = Float64(ll[i])
    end
end

Fam  = Dict(zip(T, Float64.(col(lab, "family_hours", "family"))))
Hmax = Dict(zip(T, Float64.(col(lab, "hiring_limit", "hired_hours_cap", "hire_max", "cap", "limit"))))
Wage = Dict(zip(T, Float64.(col(lab, "hired_cost_EUR_per_h", "hired_cost", "wage"))))

WT = string.(col(wat, "period"))
Inflow = Dict(zip(WT, Float64.(col(wat, "inflow"))))
Pmax   = Dict(zip(WT, Float64.(col(wat, "pump_capacity", "pumping_capacity", "pump_max", "pump"))))



MC = string.(col(mkt, "crop"))

raw_prices = col(mkt, "price_EUR_per_t", "price_eur", "price")
price_vals = [ismissing(p) ? 0.0 : Float64(p) for p in raw_prices]

price  = Dict(zip(MC, price_vals))
cmin   = Dict(zip(MC, opt.(col(mkt, "contract_min_t", "contract_min"))))
cmax   = Dict(zip(MC, opt.(col(mkt, "contract_max_t", "contract_max"))))
pfree  = Dict(zip(MC, opt.(col(mkt, "spot_price_EUR_per_t", "spot_price", "spot", "free_market_price", "free_price", "free"))))

P = Dict(norm(k) => Float64(v) for (k, v) in zip(col(par, "parameter", "name", "key"), col(par, "value")))

# Helper inline senza problemi di world age
function fetch_param(P_dict, candidates...)
    for cand in candidates
        nc = norm(cand)
        # 1. Cerca corrispondenza esatta
        haskey(P_dict, nc) && return P_dict[nc]
        # 2. Cerca contenimento
        for (k, v) in P_dict
            occursin(nc, k) && return v
        end
    end
    error("Parametro non trovato tra $(candidates). Chiavi disponibili in parameters.csv: $(collect(keys(P_dict)))")
end

R0      = fetch_param(P, "reservoirinitial", "reservoir_initial", "r0")
Rmax    = fetch_param(P, "reservoircapacity", "reservoir_max", "max_reservoir", "rmax")
Rterm   = fetch_param(P, "reservoirterminal", "reservoir_terminal", "rterm")
Lpermit = fetch_param(P, "abstractionlicence", "abstraction_permit", "permit")
pumpc   = fetch_param(P, "pumpingcost", "pumping_cost")          # EUR / m3
npshare = fetch_param(P, "nonproductiveshare", "non_productive_share")
# ------------------------------------------------------------------ model
m = Model(Gurobi.Optimizer)

@variable(m, x[b in B, c in C] >= 0)                 # ha of crop c on block b
@variable(m, 0 <= q[t in T] <= Pmax[t])              # pumped volume (m3)
@variable(m, 0 <= r[t in T] <= Rmax)                 # reservoir level at end of period
@variable(m, s[t in T] >= 0)                         # spilled inflow (m3)
@variable(m, 0 <= h[t in T] <= Hmax[t])              # hired hours
@variable(m, sc[c in C] >= 0)                        # tonnes sold at contract / base price
@variable(m, sf[c in C] >= 0)                        # tonnes sold at free-market price

prod(c) = sum(Y[(c, soil[b])] * x[b, c] for b in B)

# 1. Land
@constraint(m, land[b in B], sum(x[b, c] for c in C) == area[b])

# 3. Water balance (reservoir)
@constraint(m, wbal[i in 1:nT],
    r[T[i]] == (i == 1 ? R0 : r[T[i-1]]) + Inflow[T[i]] + q[T[i]] - s[T[i]] -
               sum(wreq[(c, T[i])] * x[b, c] for b in B, c in C))
@constraint(m, permit, sum(q[t] for t in T) <= Lpermit)

# 4. Terminal reserve
@constraint(m, terminal, r[T[nT]] >= Rterm)

# 5. Labour
@constraint(m, labc[t in T],
    sum(lreq[(c, t)] * x[b, c] for b in B, c in C) <= Fam[t] + h[t])

# 6. Sales / contracts
for c in C
    if haskey(price, c)
        @constraint(m, prod(c) == sc[c] + sf[c])
        if cmax[c] === nothing || pfree[c] === nothing
            fix(sf[c], 0.0; force = true)             # single price, unlimited
        else
            @constraint(m, sc[c] <= cmax[c])
            pfree[c] > price[c] && @warn "free price > contract price for $c: LP is not valid"
        end
        if cmin[c] !== nothing
            @constraint(m, prod(c) >= cmin[c])
        end
    else                                              # e.g. fallow: no sales
        fix(sc[c], 0.0; force = true); fix(sf[c], 0.0; force = true)
    end
end

# 7. Diversification
@constraint(m, divers[c in C; c != fallow], sum(x[b, c] for b in B) <= dshare[c] * farm_area)

# 8. Non-productive area
@constraint(m, nonprod, sum(x[b, fallow] for b in B) >= npshare * farm_area)

# Objective: revenue - variable costs - wages - pumping
revenue = sum(price[c] * sc[c] + (pfree[c] === nothing ? 0.0 : pfree[c]) * sf[c]
              for c in C if haskey(price, c))
varcost = sum(vcost[c] * x[b, c] for b in B, c in C)
@objective(m, Max, revenue - varcost - sum(Wage[t] * h[t] for t in T) - pumpc * sum(q[t] for t in T))

optimize!(m)
@assert termination_status(m) == MOI.OPTIMAL


println("\n=========== RESULTS ===========")
@printf("Optimal gross margin: %.2f EUR\n", objective_value(m))

println("\nCropping plan (ha) by block:")
used = [c for c in C if sum(value(x[b, c]) for b in B) > 1e-6]
plan = DataFrame(block = B, area = [area[b] for b in B], soil = [soil[b] for b in B])
for c in used
    plan[!, c] = [round(value(x[b, c]), digits = 3) for b in B]
end
show(plan, allrows = true, allcols = true); println()

println("\nTotal area per crop (ha) and share of farm:")
for c in used
    a = sum(value(x[b, c]) for b in B)
    @printf("  %-14s %8.2f ha  (%5.1f%%)\n", c, a, 100a / farm_area)
end

println("\nWater use by period (m3):")
@printf("  %-4s %10s %10s %10s %10s %10s %12s\n", "per", "inflow", "pumped", "irrigation", "spilled", "end level", "dual")
for (i, t) in enumerate(T)
    irr = sum(wreq[(c, t)] * value(x[b, c]) for b in B, c in C)
    @printf("  %-4s %10.0f %10.0f %10.0f %10.0f %10.0f %12.5f\n", t, Inflow[t], value(q[t]), irr,
            value(s[t]), value(r[t]), dual(wbal[i]))
end
@printf("  Annual pumping: %.0f / %.0f m3 (permit dual = %.5f EUR/m3)\n",
        sum(value(q[t]) for t in T), Lpermit, dual(permit))

println("\nLabour by period (h):")
@printf("  %-4s %10s %10s %10s %10s %12s\n", "per", "needed", "family", "hired", "hire cap", "dual")
for t in T
    need = sum(lreq[(c, t)] * value(x[b, c]) for b in B, c in C)
    @printf("  %-4s %10.1f %10.1f %10.1f %10.1f %12.4f\n", t, need, Fam[t], value(h[t]), Hmax[t], dual(labc[t]))
end

println("\nBinding (exhausted) resources / constraints:")
tol = 1e-6
for (i, t) in enumerate(T)
    value(r[t]) >= Rmax - tol && println("  reservoir full at end of $t")
    value(q[t]) >= Pmax[t] - tol && println("  pump capacity saturated in $t")
    value(s[t]) > tol && println("  inflow spilled in $t: $(round(value(s[t]), digits=1)) m3")
    value(h[t]) >= Hmax[t] - tol && println("  hiring cap reached in $t")
    value(h[t]) <= tol && abs(dual(labc[t])) < 1e-9 &&
        println("  family labour NOT exhausted in $t (no hiring)")
    value(h[t]) > tol && value(h[t]) < Hmax[t] - tol &&
        println("  labour in $t: family hours exhausted, hiring partial")
end
sum(value(q[t]) for t in T) >= Lpermit - tol && println("  annual abstraction permit exhausted")
value(r[T[nT]]) <= Rterm + tol && println("  terminal reserve requirement binding")
for c in C
    c == fallow && continue
    sum(value(x[b, c]) for b in B) >= dshare[c] * farm_area - tol &&
        println("  diversification cap binding for $c")
end
sum(value(x[b, fallow]) for b in B) <= npshare * farm_area + tol &&
    println("  non-productive area constraint binding")
for c in C
    haskey(price, c) && cmin[c] !== nothing && value(prod(c)) <= cmin[c] + tol &&
        println("  contract minimum binding for $c")
    haskey(price, c) && cmax[c] !== nothing && value(sc[c]) >= cmax[c] - tol &&
        println("  contract ceiling reached for $c (excess sold at free price)")
end
