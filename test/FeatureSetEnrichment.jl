using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab.DA, "FeatureSetEnrichment")

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

    @test BioLab.FeatureSetEnrichment._get_absolute_raise(SC_, ID, ex) == re

    # 3.625 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # 1.792 ns (0 allocations: 0 bytes)
    # 3.666 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 1.792 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 5.208 ns (0 allocations: 0 bytes)
    # 2.416 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    # 5.541 ns (0 allocations: 0 bytes)
    # 12.470 ns (0 allocations: 0 bytes)
    # 12.470 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._get_absolute_raise($SC_, $ID, $ex)

end

# ---- #

const BO_ = [true, false, true, false, true, true, false, false, true]

# ---- #

for (ex, re) in (
    (1, (N, 6.4, 4.0)),
    (1.0, (N, 6.4, 4.0)),
    (2, (N, 16.06, 4.0)),
    (2.0, (N, 16.06, 4.0)),
    (0.1, (N, 4.068020158853387, 4.0)),
    (0.5, (N, 4.672336016204768, 4.0)),
)

    @test BioLab.FeatureSetEnrichment._sum_10(SC_, ex, BO_) == re

    # 9.217 ns (0 allocations: 0 bytes)
    # 7.333 ns (0 allocations: 0 bytes)
    # 20.770 ns (0 allocations: 0 bytes)
    # 28.224 ns (0 allocations: 0 bytes)
    # 54.442 ns (0 allocations: 0 bytes)
    # 54.483 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._sum_10($SC_, $ex, $BO_)

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

    @test BioLab.FeatureSetEnrichment._sum_all1(SC_, ex, BO_) == re

    # 8.884 ns (0 allocations: 0 bytes)
    # 8.884 ns (0 allocations: 0 bytes)
    # 25.309 ns (0 allocations: 0 bytes)
    # 49.426 ns (0 allocations: 0 bytes)
    # 97.427 ns (0 allocations: 0 bytes)
    # 97.456 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._sum_all1($SC_, $ex, $BO_)

end

# ---- #

BioLab.FeatureSetEnrichment._plot_mountain(
    joinpath(BioLab.TE, "plot_mountain.html"),
    [2.0, 0, -2],
    ["Set Feature 1", "Set Feature 2", "Set Feature 3"],
    [true, true, true],
    [0.1, 0, -0.1],
    11.41,
)

# ---- #

const AL_ = (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KSa(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioP(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

# ---- #

for (al, re) in zip(AL_, ("KS", "KSa", "KLi", "KLioP", "KLioM"))

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

fe_, sc_, fe1_ = benchmark_card("AK")

bo_ = in(Set(fe1_)).(fe_)

for al in AL_

    for mo_ in (nothing, Vector{Float64}(undef, length(bo_)))

        BioLab.FeatureSetEnrichment._enrich(al, sc_, EX, bo_, mo_)

    end

    # 17.493 ns (0 allocations: 0 bytes)
    # 15.531 ns (0 allocations: 0 bytes)
    # 134.355 ns (0 allocations: 0 bytes)
    # 229.858 ns (0 allocations: 0 bytes)
    # 229.760 ns (0 allocations: 0 bytes)

    # 23.176 ns (0 allocations: 0 bytes)
    # 21.606 ns (0 allocations: 0 bytes)
    # 144.306 ns (0 allocations: 0 bytes)
    # 242.131 ns (0 allocations: 0 bytes)
    # 242.079 ns (0 allocations: 0 bytes)
    @btime BioLab.FeatureSetEnrichment._enrich($al, $sc_, $EX, $bo_, nothing)

end

# ---- #

function benchmark_myc()

    di = joinpath(BioLab.DA, "FeatureSetEnrichment")

    da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

    reverse!(da[!, 1]),
    reverse!(da[!, 2]),
    BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

end

# ---- #

fe_, sc_, fe1_ = benchmark_myc()

bo_ = in(Set(fe1_)).(fe_)

sa_ = ["Score", "Score x 10", "Constant"]

fe_x_sa_x_sc = hcat(sc_, sc_ * 10.0, fill(0.8, length(fe_)))

se_fe1_ = BioLab.GMT.read(joinpath(DA, "h.all.v7.1.symbols.gmt"))

se_ = collect(keys(se_fe1_))

fe1___ = collect(values(se_fe1_))

for al in AL_

    # 45.208 μs (0 allocations: 0 bytes)
    # 3.044 ms (108 allocations: 934.22 KiB)
    # 9.672 ms (358 allocations: 4.59 MiB)
    # 37.166 μs (0 allocations: 0 bytes)
    # 2.659 ms (108 allocations: 934.22 KiB)
    # 8.431 ms (358 allocations: 4.59 MiB)
    # 210.333 μs (0 allocations: 0 bytes)
    # 11.439 ms (108 allocations: 934.22 KiB)
    # 35.276 ms (358 allocations: 4.59 MiB)
    # 352.542 μs (0 allocations: 0 bytes)
    # 18.786 ms (108 allocations: 934.22 KiB)
    # 57.324 ms (358 allocations: 4.59 MiB)
    # 352.416 μs (0 allocations: 0 bytes)
    # 18.812 ms (108 allocations: 934.22 KiB)
    # 57.440 ms (358 allocations: 4.59 MiB)

    @btime BioLab.FeatureSetEnrichment._enrich($al, $sc_, $EX, $bo_, nothing)

    @btime BioLab.FeatureSetEnrichment.enrich($al, $sc_, $fe_, $fe1___)

    @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sa_, $fe_x_sa_x_sc, $se_, $fe1___)

end

# ---- #

function benchmark_random(n, n1)

    fe_ = string.("Feature ", n:-1:1)

    fe_,
    reverse!(BioLab.NumberVector.simulate(cld(n, 2); ze = iseven(n))),
    sample(fe_, n1; replace = false)

end
