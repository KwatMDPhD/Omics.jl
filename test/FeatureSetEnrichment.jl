include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "FeatureSetEnrichment")

@test readdir(DA) ==
      ["c2.all.v7.1.symbols.gmt", "gene_x_statistic_x_number.tsv", "h.all.v7.1.symbols.gmt"]

# ---- #

sc_ = [-2.0, -1, 0, 0, 1, 2]

n = length(sc_)

# ---- #

id = 1

for (ex, re) in ((-1.0, 0.5), (1.0, 2.0), (2.0, 4.0), (3.0, 8.0))

    @test BioLab.FeatureSetEnrichment._get_absolute_raise(sc_, id, ex) == re

    # 5.792 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    #@btime BioLab.FeatureSetEnrichment._get_absolute_raise($sc_, $id, $ex)

end

# ---- #

bo_ = [true, true, false, true, false, true]

for (ex, re) in ((1.0, (n, 5.0, 2.0)), (2.0, (n, 9.0, 2.0)))

    @test BioLab.FeatureSetEnrichment._sum_10(sc_, ex, bo_) == re

    # 5.833 ns (0 allocations: 0 bytes)
    # 19.121 ns (0 allocations: 0 bytes)    
    #@btime BioLab.FeatureSetEnrichment._sum_10($sc_, $ex, $bo_)

end

# ---- #

for (ex, re) in ((1.0, (n, 6.0, 5.0)), (2.0, (n, 10.0, 9.0)))

    @test BioLab.FeatureSetEnrichment._sum_all1(sc_, ex, bo_) == re

    # 7.125 ns (0 allocations: 0 bytes)
    # 28.839 ns (0 allocations: 0 bytes)
    #@btime BioLab.FeatureSetEnrichment._sum_all1($sc_, $ex, $bo_)

end

# ---- #

BioLab.FeatureSetEnrichment._plot_mountain(
    joinpath(TE, "plot_mountain.html"),
    [2.0, -2],
    ["Black Beard", "Law"],
    [true, true],
    [0.1, -0.1],
    11.29,
)

# ---- #

function benchmark_random(n, n1)

    fe_ = map(id -> "Feature $id", n:-1:1)

    fe_,
    reverse!(BioLab.NumberVector.simulate(cld(n, 2); ze = iseven(n))),
    sample(fe_, n1; replace = false)

end

# ---- #

function benchmark_card(ca1)

    ["K", "Q", "J", "X", "9", "8", "7", "6", "5", "4", "3", "2", "A"],
    [6.0, 5, 4, 3, 2, 1, 0, -1, -2, -3, -4, -5, -6],
    [string(ca) for ca in ca1]

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

for (al, re) in (
    (BioLab.FeatureSetEnrichment.KS(), "KS"),
    (BioLab.FeatureSetEnrichment.KSa(), "KSa"),
    (BioLab.FeatureSetEnrichment.KLi(), "KLi"),
    (BioLab.FeatureSetEnrichment.KLioP(), "KLioP"),
    (BioLab.FeatureSetEnrichment.KLioM(), "KLioM"),
)

    @test BioLab.FeatureSetEnrichment.make_string(al) == re

end

# ---- #

fe_, sc_, fe1_ = benchmark_card("AK")

bo_ = BioLab.Collection.is_in(fe_, fe1_)

# 17.159 ns (0 allocations: 0 bytes)
# 14.780 ns (0 allocations: 0 bytes)
# 136.541 ns (0 allocations: 0 bytes)
# 234.256 ns (0 allocations: 0 bytes)
# 234.397 ns (0 allocations: 0 bytes)
for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KSa(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioP(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

    for mo_ in (nothing, Vector{Float64}(undef, length(bo_)))

        BioLab.FeatureSetEnrichment._enrich(al, sc_, 1.0, bo_, mo_)

    end

    #@btime BioLab.FeatureSetEnrichment._enrich($al, $sc_, 1.0, $bo_, nothing)

end

# ---- #

fe_, sc_, fe1_ = benchmark_myc()

bo_ = BioLab.Collection.is_in(fe_, fe1_)

sa_ = ["Score", "Score x 10", "Constant"]

fe_x_sa_x_sc = hcat(sc_, sc_ * 10.0, fill(0.8, length(fe_)))

se_fe1_ = BioLab.GMT.read(joinpath(DA, "h.all.v7.1.symbols.gmt"))

se_ = collect(keys(se_fe1_))

fe1___ = collect(values(se_fe1_))

# 45.583 μs (0 allocations: 0 bytes)
# 3.085 ms (108 allocations: 1.74 MiB)
# 9.863 ms (380 allocations: 8.92 MiB)
# 37.167 μs (0 allocations: 0 bytes)
# 2.671 ms (108 allocations: 1.74 MiB)
# 8.402 ms (380 allocations: 8.92 MiB)
# 207.250 μs (0 allocations: 0 bytes)
# 11.166 ms (108 allocations: 1.74 MiB)
# 33.891 ms (380 allocations: 8.92 MiB)
# 356.041 μs (0 allocations: 0 bytes)
# 18.604 ms (108 allocations: 1.74 MiB)
# 56.384 ms (380 allocations: 8.92 MiB)
# 356.209 μs (0 allocations: 0 bytes)
# 18.594 ms (108 allocations: 1.74 MiB)
# 56.205 ms (380 allocations: 8.92 MiB)
for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KSa(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioP(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

    #@btime BioLab.FeatureSetEnrichment._enrich($al, $sc_, 1.0, $bo_, nothing)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $sc_, $fe_, $fe1___)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sa_, $fe_x_sa_x_sc, $se_, $fe1___)

end
