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
    "Distance",
    "Entropy",
    #"ErrorMatrix", # 12
    "Evidence",
    #"Extreme", # 4
    #"GEO", # 201
    #"GPSMap", # 101
    "Gene",
    #"GeneralizedLinearModel", # 11
    "Grid",
    "HTM",
    "Information",
    #"Kumo", # 102
    "Ma",
    #"Match", # 5
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
    #"Significance", # 3
    #"Simulation", # 6
    "Strin",
    "Table",
    #"Target", # 2
    #"XSample", # 202
    #"XSampleCharacteristic", # 203
    #"XSampleFeature", # 204
    #"XSampleSelect", # 205
)

    @info "🎬 Testing $na"

    run(`julia --project $na.jl`)

end
