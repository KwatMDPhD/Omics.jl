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
    "Evidence",
    "GL",
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
    "Rank",
    "Significance",
    "Simulation.jl",
    "Strin",
    "Table",
)

    @info mo

    run(`julia --project $mo.jl`)

end
