using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in ("Color", "Dic", "HTM", "Palette", "Path", "Plot", "Strin", "Table")

    @info mo

    run(`julia --project $mo.jl`)

end
