module Omics

# ----------------------------------------------------------------------------------------------- #

for na in (
    "Animation",
    "CartesianCoordinate",
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
    "PolarCoordinate",
    "Probability",
    "ROC",
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
