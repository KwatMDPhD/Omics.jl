using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in (
    "Color",
    "Density",
    "Dic",
    "Distance",
    "Entropy",
    "Evidence",
    "GL",
    "Grid",
    "HTM",
    "Information",
    "MutualInformation",
    "Normalization",
    "Palette",
    "Path",
    "Plot",
    "Probability",
    "ROC",
    "Significance",
    "Strin",
    "Table",
)

    @info mo

    run(`julia --project $mo.jl`)

end
