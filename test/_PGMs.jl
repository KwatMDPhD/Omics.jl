using PGMs

using Aqua: test_all, test_ambiguities

using Test: @test

test_all(PGMs; ambiguities = false, deps_compat = false)

test_ambiguities(PGMs)

# ----------------------------------------------------------------------------------------------- #

for jl in ("Nodes.jl", "Factors.jl", "Graphs.jl")

    @info "Testing $jl"

    run(`julia --project $jl`)

end
