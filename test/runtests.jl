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
    "Match",
    "MatrixFactorization",
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
    "Target",
    "XSample",
)

    @info "🎬 Running $mo"

    run(`julia --project $mo.jl`)

end
