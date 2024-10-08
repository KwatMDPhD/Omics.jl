using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in ("Color", "Dictionary", "HTM", "Palette", "Plot", "Strin", "Table")

    @info mo

    run(`julia --project $mo.jl`)

end
