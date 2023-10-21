using Test: @test

using BioLab

# ---- #

for (na_, an___) in ((
    ["Row", "Column 1", "Column 2", "Column 3"],
    ([1, 2, 3], ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']),
),)

    BioLab.FeatureXSample.count(na_, an___)

end

# ---- #

const FE_ = (id -> "Feature $id").([1, 1, 2, 3, 2, 3, 4])

# ---- #

const SA_ = ["Sample 1"]

# ---- #

const FEU_ = unique(FE_)

# ---- #

const FE2U_ = replace.(FEU_, "Feature" => "New Feature")

# ---- #

@test BioLab.FeatureXSample.transform(
    BioLab.TE,
    FE_,
    SA_,
    [-1.0; 1; 0; -2; 2; 8; 7;;],
    fe_fe2 = Dict(zip(FEU_, FE2U_)),
    fu = BioLab.FeatureXSample.median,
    ty = Float64,
    lo = true,
    na = "Test",
) == (FE2U_, [0.0; 1; 2; 3;;])

# ---- #

for fi in ("feature_x_sample_x_number.html", "number.html", "number_plus1_log2.html")

    @test isfile(joinpath(BioLab.TE, fi))

end
