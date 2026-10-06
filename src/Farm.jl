module Farm

using JuMP
using Gurobi
using CSV
using Dataframes

model = Model(Gurobi.Optimizer)


@variable(model, x >= 0)
@variable(model, y >= 0)

@objective(model, Max, 3x + 2y)

@constraint(model, x + y <= 4)
@constraint(model, 2x + y <= 5)

optimize!(model)

println("Termination status: ", termination_status(model))
println("Objective value: ", objective_value(model))
println("x = ", value(x))
println("y = ", value(y))

end # module Farm
