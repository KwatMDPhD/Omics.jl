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
    #"ErrorMatrix", # 2
    "Evidence",
    "Extreme",
    #"GEO", # 21
    #"GPSMap", # 11
    "Gene",
    #"GeneralizedLinearModel", # 1
    "Grid",
    "HTM",
    "Information",
    #"Kumo", # 31
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
    #"ReceiverOperatingCharacteristic", # 3
    "Significance",
    "Strin",
    "Table",
    "Target",
    #"XSample", # 22
    #"XSampleCharacteristic", # 23
    #"XSampleFeature", # 24
    #"XSampleSelect", # 25
)

    @info "🎬 Testing $na"

    run(`julia --project $na.jl`)

end
