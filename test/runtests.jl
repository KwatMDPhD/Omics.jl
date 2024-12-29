using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in (
    "Clustering",
    "Color",
    "Density",
    "Dic",
    "Distance",
    "Entropy",
    "ErrorMatrix",
    "Evidence",
    "Extreme",
    "GeneralizedLinearModel",
    "Grid",
    "HTM",
    "Information",
    "Match",
    "Matri",
    "MutualInformation",
    "Normalization",
    "Palette",
    "Path",
    "Plot",
    "Probability",
    "ROC",
    "Significance",
    "Simulation",
    "Strin",
    "Table",
)

    @info mo

    run(`julia --project $mo.jl`)

end
