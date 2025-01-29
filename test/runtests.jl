using Test: @test

using Omics

# ----------------------------------------------------------------------------------------------- #

for mo in (
    "Clustering",
    "Color",
    "Cytoscape",
    "Density",
    "Dic",
    "Distance",
    "Entropy",
    "ErrorMatrix",
    "Evidence",
    "Extreme",
    "GEO",
    "Gene",
    "GeneralizedLinearModel",
    "Grid",
    "HTM",
    "Information",
    "Kumo",
    "Match",
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
