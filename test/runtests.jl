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
    #"ErrorMatrix", # 8
    #"Evidence", # 1
    #"Extreme", # 6
    #"GEO", # 101
    #"GPSMap", # 201
    "Gene",
    #"GeneralizedLinearModel", # 9
    "Grid",
    "HTM",
    "Information",
    #"Kumo", # 301
    "Ma",
    #"Match", # 7
    "MatrixFactorization",
    #"MutualInformation", # 2
    #"Normalization", # 3
    "Numbe",
    "Path",
    "Plot",
    "PolarCoordinate",
    "Probability",
    #"ReceiverOperatingCharacteristic", # 10
    #"Significance", # 5
    #"Simulation", # ?
    "Strin",
    "Table",
    #"Target", # 4
    #"XSample", # 102
    #"XSampleCharacteristic", # 103
    #"XSampleFeature", # 104
    #"XSampleSelect", # 105
)

    @info "🎬 Testing $na"

    run(`julia --project $na.jl`)

end
