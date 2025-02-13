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
    #"Density",
    "Dic",
    "Distance",
    #"Entropy", # 21
    #"ErrorMatrix", # 31
    #"Evidence", # 41
    #"Extreme", # 11
    #"GEO", # 101
    #"GPSMap", # 42
    "Gene", # 5
    #"GeneralizedLinearModel",
    #"Grid",
    "HTM",
    #"Information", # 23
    #"Kumo",
    "Ma",
    #"Match", # 13
    "MatrixFactorization",
    #"MutualInformation", # 24
    #"Normalization",
    "Numbe",
    "Path",
    "Plot",
    "PolarCoordinate",
    #"Probability", # 22
    #"ROC", # 32
    #"Significance", # 12
    #"Simulation",
    "Strin", # 3
    "Table", # 4
    #"Target", # 14
    #"XSample", # 102
    #"XSampleCharacteristic", # 103
    #"XSampleFeature", # 104
    #"XSampleSelect", # 105
)

    @info "🎬 Testing $na"

    run(`julia --project $na.jl`)

end
