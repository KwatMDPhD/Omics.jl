using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in (
    "Color",
    "Density",
    "Dic",
    "Evidence",
    "HTM",
    "Normalization",
    "Palette",
    "Path",
    "Plot",
    "Significance",
    "Strin",
    "Table",
)

    @info mo

    run(`julia --project $mo.jl`)

end
