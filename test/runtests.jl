using Test: @test

using Omics

# ----------------------------------------------------------------------------------------------- #

for mo in (
    "Clustering",
    "Color",
    "Coordinate",
    "Cytoscape",
    "Density",
    "Dic",
    "Distance",
    "Entropy",
    "ErrorMatrix",
    "Evidence",
    "Extreme",
    "GEO",
    "GPSMap",
    "Gene",
    "GeneralizedLinearModel",
    "Grid",
    "HTM",
    "Information",
    "Kumo",
    "Ma",
    "Match",
    "MatrixFactorization",
    "MutualInformation",
    "Normalization",
    "Numbe",
    "Palette",
    "Path",
    "Plot",
    "Probability",
    "ROC",
    "Significance",
    "Simulation",
    "Strin",
    "Table",
    "Target",
    "XSample",
)

    run(`julia --project $mo.jl`)

end
