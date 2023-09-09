using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

include("Bad.jl")

@test BioLab.Error.@is BioLab.FeatureXSample.error_describe(["Label"], [BA_])

# ---- #

BioLab.FeatureXSample.error_describe(
    ["Column Row", "Column 1", "Column 2", "Column 3"],
    [["Row $id" for id in 1:3], ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']],
)

# ---- #

const FE_ = [1, 1, 2, 3, 2, 3, 4]

const FEU_ = unique(FE_)

const PR = "New Feature "

@test BioLab.FeatureXSample.error_rename_collapse_log2_plot(
    BioLab.TE,
    ["Feature $fe" for fe in FE_],
    reshape([-1, 1, 0, -2, 2, 8, 7], :, 1),
    Dict("Feature $fe" => "$PR$fe" for fe in FEU_),
    true,
    "Test",
) == (["$PR$fe" for fe in FEU_], reshape([0.0, 1, 2, 3], :, 1))
