using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for mo in (
    "Color",
    "Density",
    "Dic",
    "Distance",
    "Entropy",
    "Evidence",
    "HTM",
    "Information",
    "MutualInformation",
    "MutualInformation2.jl",
    "Normalization",
    "Palette",
    "Path",
    "Plot",
    "Probability",
    "Significance",
    "Strin",
    "Table",
    #"ROC",
)

    @info mo

    run(`julia --project $mo.jl`)

end
