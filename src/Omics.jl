module Omics

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
    "Path",
    "Plot",
    "PolarCoordinate",
    "Probability",
    "ReceiverOperatingCharacteristic",
    "Significance",
    "Simulation",
    "Strin",
    "Table",
    "Target",
    "XSample",
    "XSampleCharacteristic",
    "XSampleFeature",
    "XSampleSelect",
)

    include("$na.jl")

end

end
