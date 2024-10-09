using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in
    ("Color", "Dic", "HTM", "Normalization", "Palette", "Path", "Plot", "Strin", "Table")

    @info mo

    run(`julia --project $mo.jl`)

end
