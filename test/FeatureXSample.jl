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

const DI = joinpath(homedir(), "Downloads")

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
    DI,
    FE_,
    SA_,
    [-1.0; 1; 0; -2; 2; 8; 7;;],
    fe_fe2 = Dict(zip(FEU_, FE2U_)),
    fu = Nucleus.FeatureXSample.median,
    ty = Float64,
    lo = true,
    naf = "FF",
    nas = "SS",
    nan = "NN",
) == (FE2U_, [0.0; 1; 2; 3;;])

# ---- #

for fi in ("ff_x_ss_x_nn.html", "ffssnn.html", "ffssnn_plus1_log2.html")

    @test isfile(joinpath(DI, fi))

end

# ---- #

const GS = "GSE14577"

# ---- #

@test Nucleus.Error.@is Nucleus.FeatureXSample.get_geo(DI, GS)

# ---- #

for pl in ("GPL96", "GPL97")

    Nucleus.FeatureXSample.get_geo(DI, GS, pl; nas = "$(pl)Sample")

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
