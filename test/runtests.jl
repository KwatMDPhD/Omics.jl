using Test: @test

using Omics

# ----------------------------------------------------------------------------------------------- #

for na in (
    "Animation",
    "CartesianCoordinate",
    "Clustering",
    "Color",
    "Coloring",
    "Coordinate",
    "Cytoscape",
    "Density",
    "Dic",
    "Difference",
    "Distance",
    "Entropy",
    #"ErrorMatrix", # 12
    "Evidence",
    "Extreme",
    #"GEO", # 201
    #"GPSMap", # 101
    "Gene",
    #"GeneralizedLinearModel", # 11
    "Grid",
    "HTM",
    "Information",
    #"Kumo", # 102
    "Ma",
    "Match",
    "MatchPlot",
    "MatrixFactorization",
    "MutualInformation",
    "Normalization",
    "Numbe",
    "Path",
    "Plot",
    "PolarCoordinate",
    "Probability",
    "Protein",
    "RangeNormalization",
    "RankNormalization",
    #"ReceiverOperatingCharacteristic", # 13
    "Significance",
    "Strin",
    "Table",
    "Target",
    #"XSample", # 202
    #"XSampleCharacteristic", # 203
    #"XSampleFeature", # 204
    #"XSampleSelect", # 205
)

    @info "🎬 Testing $na"

    run(`julia --project $na.jl`)

end
