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
    "Difference",
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
    "ReceiverOperatingCharacteristic",
    "Significance",
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
