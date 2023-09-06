using DataFrames: DataFrame

using Test: @test

using BioLab

# ---- #

const N_RO = 3

const FEATURE_X_SAMPLE_X_ANY = DataFrame(
    "Feature" => ["Feature $id" for id in 1:N_RO],
    "Column 1" => ('A':'Z')[1:N_RO],
    "Column 2" => ('A':'Z')[1:N_RO],
    "Column 3" => ('A':'Z')[(N_RO + 1):(N_RO + N_RO)],
)

BioLab.FeatureXSample.describe(FEATURE_X_SAMPLE_X_ANY)

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
