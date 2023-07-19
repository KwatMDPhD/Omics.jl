using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "FeatureSetEnrichment")

# ---- #

@test readdir(DA) ==
      ["c2.all.v7.1.symbols.gmt", "gene_x_statistic_x_number.tsv", "h.all.v7.1.symbols.gmt"]

# ---- #

const SC_ = [-2, -1, -0.5, 0, 0, 0.5, 1, 2, 3.4]

const N = length(SC_)

# ---- #

const ID = 1

for (ex, re) in (
    (-1, 0.5),
    (-1.0, 0.5),
    (0, 1),
    (0.0, 1),
    (1, 2),
    (1.0, 2),
    (2, 4),
    (2.0, 4),
    (3, 8),
    (3.0, 8),
    (4, 16),
    (4.0, 16),
    (0.1, 1.0717734625362931),
    (0.5, sqrt(2)),
)

    @test BioLab.FeatureSetEnrichment._index_absolute_exponentiate(SC_, ID, ex) == re

    # 3.625 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 3.625 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 5.208 ns (0 allocations: 0 bytes)
    # 2.416 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    # 5.541 ns (0 allocations: 0 bytes)
    # 12.470 ns (0 allocations: 0 bytes)
    # 12.470 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._index_absolute_exponentiate($SC_, $ID, $ex)

end

# ---- #

const IS_ = [true, false, true, false, true, true, false, false, true]

# ---- #

for (ex, re) in (
    (1, (N, 4.0, 6.4)),
    (1.0, (N, 4.0, 6.4)),
    (2, (N, 4.0, 16.06)),
    (2.0, (N, 4.0, 16.06)),
    (0.1, (N, 4.0, 4.068020158853387)),
    (0.5, (N, 4.0, 4.672336016204768)),
)

    @test BioLab.FeatureSetEnrichment._sum_01(SC_, ex, IS_) == re

    # 9.217 ns (0 allocations: 0 bytes)
    # 7.333 ns (0 allocations: 0 bytes)
    # 20.770 ns (0 allocations: 0 bytes)
    # 28.224 ns (0 allocations: 0 bytes)
    # 54.442 ns (0 allocations: 0 bytes)
    # 54.483 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._sum_01($SC_, $ex, $IS_)

end

# ---- #

for (ex, re) in (
    (1, (N, 10.4, 6.4)),
    (1.0, (N, 10.4, 6.4)),
    (2, (N, 22.06, 16.06)),
    (2.0, (N, 22.06, 16.06)),
    (0.1, (N, 7.13979362138968, 4.068020158853387)),
    (0.5, (N, 8.086549578577863, 4.672336016204768)),
)

    @test BioLab.FeatureSetEnrichment._sum_all1(SC_, ex, IS_) == re

    # 8.884 ns (0 allocations: 0 bytes)
    # 8.884 ns (0 allocations: 0 bytes)
    # 25.309 ns (0 allocations: 0 bytes)
    # 48.414 ns (0 allocations: 0 bytes)
    # 96.272 ns (0 allocations: 0 bytes)
    # 96.417 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._sum_all1($SC_, $ex, $IS_)

end

# ---- #

BioLab.FeatureSetEnrichment._plot_mountain(
    joinpath(BioLab.TE, "plot_mountain.html"),
    ["Set Feature 1", "Set Feature 2", "Set Feature 3"],
    [2.0, 0, -2],
    [true, true, true],
    [0.1, 0, -0.1],
    11.41;
    title_text = join((1:9..., 0))^10,
)

# ---- #

const AL_ = (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KSa(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioM(),
    BioLab.FeatureSetEnrichment.KLioP(),
)

# ---- #

for (al, re) in zip(AL_, ("KS", "KSa", "KLi", "KLioM", "KLioP"))

    @test BioLab.FeatureSetEnrichment.make_string(al) == re

end

# ---- #

function benchmark_card(ca1)

    ["K", "Q", "J", "X", "9", "8", "7", "6", "5", "4", "3", "2", "A"],
    [6.0, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6],
    string.(collect(ca1))

end

# ---- #

const EX = 1

# ---- #

const CFE_, CSC_, CFE1_ = benchmark_card("AK")

const CIS_ = in(Set(CFE1_)).(CFE_)

for (al, re) in zip(AL_, (-0.5, 0.0, 0.0, 0.0, 0.0))

    for mo_ in (nothing, Vector{Float64}(undef, length(CFE_)))

        BioLab.FeatureSetEnrichment._enrich(al, CSC_, EX, CIS_, mo_)

    end

    @test isapprox(
        BioLab.FeatureSetEnrichment._enrich(al, CSC_, EX, CIS_, nothing),
        re;
        atol = 1e-15,
    )

    # 16.699 ns (0 allocations: 0 bytes)
    # 22.233 ns (0 allocations: 0 bytes)
    #
    # 15.489 ns (0 allocations: 0 bytes)
    # 20.666 ns (0 allocations: 0 bytes)
    #
    # 125.510 ns (0 allocations: 0 bytes)
    # 130.567 ns (0 allocations: 0 bytes)
    #
    # 232.155 ns (0 allocations: 0 bytes)
    # 236.207 ns (0 allocations: 0 bytes)
    #
    # 232.143 ns (0 allocations: 0 bytes)
    # 236.014 ns (0 allocations: 0 bytes)

    @btime BioLab.FeatureSetEnrichment._enrich(
        $al,
        $CSC_,
        $EX,
        $(convert(Vector{Bool}, CIS_)),
        nothing,
    )

    @btime BioLab.FeatureSetEnrichment._enrich($al, $CSC_, $EX, $CIS_, nothing)

end

# ---- #

function benchmark_myc()

    di = joinpath(BioLab._DA, "FeatureSetEnrichment")

    da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

    reverse!(da[!, 1]),
    reverse!(da[!, 2]),
    BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

end

# ---- #

const MFE_, MSC_, MFE1_ = benchmark_myc()

const MIS_ = in(Set(MFE1_)).(MFE_)

const MSA_ = ["Score", "Score x 10", "Constant"]

const FE_X_SA_X_MSC = hcat(MSC_, MSC_ * 10.0, fill(0.8, length(MFE_)))

const MSE_FE1_ = BioLab.GMT.read(joinpath(DA, "h.all.v7.1.symbols.gmt"))

const MSE_ = collect(keys(MSE_FE1_))

const MFE1___ = collect(values(MSE_FE1_))

# ---- #

for (al, re) in zip(
    AL_,
    (
        0.7651927829281453,
        0.41482514169516305,
        0.7736480596525319,
        0.7750661968892066,
        0.772229922415844,
    ),
)

    @test isapprox(BioLab.FeatureSetEnrichment.enrich("", al, MSC_, MFE_, MFE1_), re; atol = 1e-12)

end

# ---- #

const AL = AL_[1]

se_x_sa_x_en = BioLab.FeatureSetEnrichment.enrich(AL, MFE_, MSA_, FE_X_SA_X_MSC, MSE_, MFE1___)

BioLab.FeatureSetEnrichment.plot(
    BioLab.TE,
    AL,
    MFE_,
    MSA_,
    FE_X_SA_X_MSC,
    MSE_,
    MFE1___,
    se_x_sa_x_en,
    "Sample",
)

# ---- #

for al in AL_

    # 43.375 μs (0 allocations: 0 bytes)
    # 2.945 ms (108 allocations: 934.22 KiB)
    # 9.522 ms (358 allocations: 4.59 MiB)
    #
    # 37.166 μs (0 allocations: 0 bytes)
    # 2.645 ms (108 allocations: 934.22 KiB)
    # 8.607 ms (358 allocations: 4.59 MiB)
    #
    # 198.208 μs (0 allocations: 0 bytes)
    # 10.629 ms (108 allocations: 934.22 KiB)
    # 33.875 ms (358 allocations: 4.59 MiB)
    #
    # 349.667 μs (0 allocations: 0 bytes)
    # 18.350 ms (108 allocations: 934.22 KiB)
    # 56.119 ms (358 allocations: 4.59 MiB)
    #
    # 349.792 μs (0 allocations: 0 bytes)
    # 18.377 ms (108 allocations: 934.22 KiB)
    # 56.183 ms (358 allocations: 4.59 MiB)

    @btime BioLab.FeatureSetEnrichment._enrich($al, $MSC_, $EX, $MIS_, nothing)

    @btime BioLab.FeatureSetEnrichment.enrich($al, $MSC_, $MFE_, $MFE1___)

    @btime BioLab.FeatureSetEnrichment.enrich($al, $MFE_, $MSA_, $FE_X_SA_X_MSC, $MSE_, $MFE1___)

end
