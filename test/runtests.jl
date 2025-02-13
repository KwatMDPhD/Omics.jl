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
    "Density", # 2
    "Dic",
    "Distance",
    "Entropy", # 3
    #"ErrorMatrix",
    #"Evidence",
    "Extreme", # 10
    #"GEO",
    #"GPSMap",
    "Gene",
    #"GeneralizedLinearModel",
    "Grid", # 1
    "HTM",
    "Information", # 5
    #"Kumo",
    "Ma",
    "Match", # 11
    "MatrixFactorization",
    "MutualInformation", # 6
    "Normalization", # 7
    "Numbe",
    "Path",
    "Plot",
    "PolarCoordinate",
    "Probability", # 4
    #"ReceiverOperatingCharacteristic",
    "Significance", # 9
    #"Simulation",
    "Strin",
    "Table",
    "Target", # 8
    #"XSample",
    #"XSampleCharacteristic",
    #"XSampleFeature",
    #"XSampleSelect",
)

    @info "🎬 Testing $na"

    run(`julia --project $na.jl`)

end
