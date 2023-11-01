using Test: @test

using Nucleus

# ---- #

for (na_, an___) in ((
    ["Row", "Column 1", "Column 2", "Column 3"],
    ([1, 2, 3], ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']),
),)

    Nucleus.FeatureXSample.count(na_, an___)

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

@test Nucleus.FeatureXSample.transform(
    Nucleus.TE,
    FE_,
    SA_,
    [-1.0; 1; 0; -2; 2; 8; 7;;],
    fe_fe2 = Dict(zip(FEU_, FE2U_)),
    fu = Nucleus.FeatureXSample.median,
    ty = Float64,
    lo = true,
    na = "Test",
) == (FE2U_, [0.0; 1; 2; 3;;])

# ---- #

for fi in ("feature_x_sample_x_number.html", "number.html", "number_plus1_log2.html")

    @test isfile(joinpath(Nucleus.TE, fi))

end

# ---- #

const DI = joinpath(homedir(), "Downloads")

# ---- #

const GS = "GSE14577"

# ---- #

@test Nucleus.Error.@is Nucleus.FeatureXSample.get_geo(DI, GS, "")

# ---- #

for pl in ("GPL96", "GPL96")

    Nucleus.FeatureXSample.get_geo(DI, GS, pl)

end

# ---- #

for (gs, ur, lo, ch) in (
    ("GSE16059", "", false, "Diagnonsis"),
    ("GSE67311", "", false, "Irritable Bowel Syndrome"),
    (
        "GSE128078",
        "ftp://ftp.ncbi.nlm.nih.gov/geo/series/GSE128nnn/GSE128078/suppl/GSE128078%5FFES%5Fisoforms%5FFPKM%2Etxt%2Egz",
        true,
        "Disease State",
    ),
    #("GSE130353", "", false, ""),
)

    @info gs

    Nucleus.FeatureXSample.get_geo(DI, gs; ur, lo, ch)

end
