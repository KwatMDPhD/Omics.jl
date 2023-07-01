include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "FeatureSetEnrichment")

@test readdir(DA) ==
      ["c2.all.v7.1.symbols.gmt", "gene_x_statistic_x_number.tsv", "h.all.v7.1.symbols.gmt"]

# ---- #

sc_ = [-2, -1, -0.5, 0, 0, 0.5, 1, 2, 3.4]

n = length(sc_)

# ---- #

id = 1

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

    @test BioLab.FeatureSetEnrichment._get_absolute_raise(sc_, id, ex) == re

    #@btime BioLab.FeatureSetEnrichment._get_absolute_raise($sc_, $id, $ex)

end

# ---- #

bo_ = [true, false, true, false, true, true, false, false, true]

# 9.217 ns (0 allocations: 0 bytes)
# 7.333 ns (0 allocations: 0 bytes)
# 20.770 ns (0 allocations: 0 bytes)
# 28.224 ns (0 allocations: 0 bytes)
# 54.442 ns (0 allocations: 0 bytes)
# 54.483 ns (0 allocations: 0 bytes)
for (ex, re) in (
    (1, (n, 6.4, 4.0)),
    (1.0, (n, 6.4, 4.0)),
    (2, (n, 16.06, 4.0)),
    (2.0, (n, 16.06, 4.0)),
    (0.1, (n, 4.068020158853387, 4.0)),
    (0.5, (n, 4.672336016204768, 4.0)),
)

    @test BioLab.FeatureSetEnrichment._sum_10(sc_, ex, bo_) == re

    #@btime BioLab.FeatureSetEnrichment._sum_10($sc_, $ex, $bo_)

end

# ---- #

# 8.884 ns (0 allocations: 0 bytes)
# 8.884 ns (0 allocations: 0 bytes)
# 25.309 ns (0 allocations: 0 bytes)
# 49.426 ns (0 allocations: 0 bytes)
# 97.427 ns (0 allocations: 0 bytes)
# 97.456 ns (0 allocations: 0 bytes)
for (ex, re) in (
    (1, (n, 10.4, 6.4)),
    (1.0, (n, 10.4, 6.4)),
    (2, (n, 22.06, 16.06)),
    (2.0, (n, 22.06, 16.06)),
    (0.1, (n, 7.13979362138968, 4.068020158853387)),
    (0.5, (n, 8.086549578577863, 4.672336016204768)),
)

    @test BioLab.FeatureSetEnrichment._sum_all1(sc_, ex, bo_) == re

    #@btime BioLab.FeatureSetEnrichment._sum_all1($sc_, $ex, $bo_)

end

# ---- #

BioLab.FeatureSetEnrichment._plot_mountain(
    joinpath(TE, "plot_mountain.html"),
    [2.0, -2],
    ["Set Feature 1", "Set Feature 2"],
    [true, true],
    [0.1, -0.1],
    11.41,
)

# ---- #

al_ = (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KSa(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioP(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

# ---- #

for (al, re) in zip(al_, ("KS", "KSa", "KLi", "KLioP", "KLioM"))

    @test BioLab.FeatureSetEnrichment.make_string(al) == re

end

# ---- #

ex = 1

# ---- #

function benchmark_card(ca1)

    ["K", "Q", "J", "X", "9", "8", "7", "6", "5", "4", "3", "2", "A"],
    [6.0, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6],
    [string(ca) for ca in ca1]

end

# ---- #

fe_, sc_, fe1_ = benchmark_card("AK")

bo_ = BioLab.Collection.is_in(fe_, fe1_)

# 17.493 ns (0 allocations: 0 bytes)
# 15.531 ns (0 allocations: 0 bytes)
# 134.355 ns (0 allocations: 0 bytes)
# 229.858 ns (0 allocations: 0 bytes)
# 229.760 ns (0 allocations: 0 bytes)
for al in al_

    for mo_ in (nothing, Vector{Float64}(undef, length(bo_)))

        BioLab.FeatureSetEnrichment._enrich(al, sc_, ex, bo_, mo_)

    end

    #@btime BioLab.FeatureSetEnrichment._enrich($al, $sc_, $ex, $bo_, nothing)

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

bo_ = BioLab.Collection.is_in(fe_, fe1_)

sa_ = ["Score", "Score x 10", "Constant"]

fe_x_sa_x_sc = hcat(sc_, sc_ * 10.0, fill(0.8, length(fe_)))

se_fe1_ = BioLab.GMT.read(joinpath(DA, "h.all.v7.1.symbols.gmt"))

se_ = collect(keys(se_fe1_))

fe1___ = collect(values(se_fe1_))

# 45.250 μs (0 allocations: 0 bytes)
# 3.082 ms (108 allocations: 1.74 MiB)
# 9.612 ms (380 allocations: 8.92 MiB)
# 37.167 μs (0 allocations: 0 bytes)
# 2.678 ms (108 allocations: 1.74 MiB)
# 8.410 ms (380 allocations: 8.92 MiB)
# 210.000 μs (0 allocations: 0 bytes)
# 11.259 ms (108 allocations: 1.74 MiB)
# 34.312 ms (380 allocations: 8.92 MiB)
# 351.917 μs (0 allocations: 0 bytes)
# 18.444 ms (108 allocations: 1.74 MiB)
# 55.918 ms (380 allocations: 8.92 MiB)
# 351.917 μs (0 allocations: 0 bytes)
# 18.425 ms (108 allocations: 1.74 MiB)
# 55.825 ms (380 allocations: 8.92 MiB)
for al in al_

    #@btime BioLab.FeatureSetEnrichment._enrich($al, $sc_, $ex, $bo_, nothing)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $sc_, $fe_, $fe1___)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sa_, $fe_x_sa_x_sc, $se_, $fe1___)

end

# ---- #

function benchmark_random(n, n1)

    fe_ = map(id -> "Feature $id", n:-1:1)

    fe_,
    reverse!(BioLab.NumberVector.simulate(cld(n, 2); ze = iseven(n))),
    sample(fe_, n1; replace = false)

end
