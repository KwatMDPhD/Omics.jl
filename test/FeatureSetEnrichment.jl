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

    @test BioLab.FeatureSetEnrichment._sum_10(sc_, bo_, ex) == re

    # 5.833 ns (0 allocations: 0 bytes)
    # 19.121 ns (0 allocations: 0 bytes)    
    #@btime BioLab.FeatureSetEnrichment._sum_10($sc_, $bo_, $ex)

end

# ---- #

for (ex, re) in ((1.0, (n, 6.0, 5.0)), (2.0, (n, 10.0, 9.0)))

    @test BioLab.FeatureSetEnrichment._sum_all1(sc_, bo_, ex) == re

    # 7.125 ns (0 allocations: 0 bytes)
    # 28.839 ns (0 allocations: 0 bytes)
    #@btime BioLab.FeatureSetEnrichment._sum_all1($sc_, $bo_, $ex)

end

# ---- #

BioLab.FeatureSetEnrichment._plot_mountain(
    joinpath(TE, "plot_mountain.html"),
    ["Black Beard", "Law"],
    [2.0, -2],
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

function _string(al)

    BioLab.String.split_get(string(al), '.', 3)[1:(end - 2)]

end

# ---- #

fe_, sc_, fe1_ = benchmark_card("AK")

bo_ = BioLab.Collection.is_in(fe_, fe1_)

for al in (
    # 19.057 ns (0 allocations: 0 bytes)
    # 132.597 ns (1 allocation: 64 bytes)
    BioLab.FeatureSetEnrichment.KS(),
    # 16.951 ns (0 allocations: 0 bytes)
    # 131.913 ns (1 allocation: 64 bytes)
    BioLab.FeatureSetEnrichment.KSa(),
    # 136.399 ns (0 allocations: 0 bytes)
    # 247.518 ns (1 allocation: 64 bytes)
    BioLab.FeatureSetEnrichment.KLi(),
    # 236.014 ns (0 allocations: 0 bytes)
    # 347.093 ns (1 allocation: 64 bytes)
    BioLab.FeatureSetEnrichment.KLioP(),
    # 235.979 ns (0 allocations: 0 bytes)
    # 347.412 ns (1 allocation: 64 bytes)
    BioLab.FeatureSetEnrichment.KLioM(),
)

    #BioLab.FeatureSetEnrichment._enrich(al, fe_, sc_, bo_; title_text = _string(al))

    #BioLab.FeatureSetEnrichment.enrich(al, fe_, sc_, fe1_; title_text = _string(al))

    #@btime BioLab.FeatureSetEnrichment._enrich($al, $fe_, $sc_, $bo_; pl = $false)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1_; pl = $false)

end

# ---- #

fe_, sc_, fe1_ = benchmark_myc()

bo_ = BioLab.Collection.is_in(fe_, fe1_)

sa_ = ["Score", "Score x 10", "Constant"]

fe_x_sa_x_sc = hcat(sc_, sc_ * 10.0, fill(0.8, length(fe_)))

se_fe1_ = BioLab.GMT.read(joinpath(DA, "h.all.v7.1.symbols.gmt"))

se_ = collect(keys(se_fe1_))

fe1___ = collect(values(se_fe1_))

for al in (
    # 45.583 μs (0 allocations: 0 bytes)
    # 785.917 μs (2 allocations: 19.67 KiB)
    # 3.050 ms (108 allocations: 1.74 MiB)
    # 9.747 ms (383 allocations: 9.38 MiB)
    BioLab.FeatureSetEnrichment.KS(),
    # 37.166 μs (0 allocations: 0 bytes)
    # 777.541 μs (2 allocations: 19.67 KiB)
    # 2.637 ms (108 allocations: 1.74 MiB)
    # 8.320 ms (383 allocations: 9.38 MiB)
    BioLab.FeatureSetEnrichment.KSa(),
    # 208.958 μs (0 allocations: 0 bytes)
    # 949.791 μs (2 allocations: 19.67 KiB)
    # 11.234 ms (108 allocations: 1.74 MiB)
    # 34.220 ms (383 allocations: 9.38 MiB)
    BioLab.FeatureSetEnrichment.KLi(),
    # 355.041 μs (0 allocations: 0 bytes)
    # 1.096 ms (2 allocations: 19.67 KiB)
    # 18.519 ms (108 allocations: 1.74 MiB)
    # 56.218 ms (383 allocations: 9.38 MiB) 
    BioLab.FeatureSetEnrichment.KLioP(),
    # 354.833 μs (0 allocations: 0 bytes)                 
    # 1.096 ms (2 allocations: 19.67 KiB)
    # 18.561 ms (108 allocations: 1.74 MiB)
    # 55.909 ms (383 allocations: 9.38 MiB)
    BioLab.FeatureSetEnrichment.KLioM(),
)

    #@btime BioLab.FeatureSetEnrichment._enrich($al, $fe_, $sc_, $bo_; pl = $false)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1_; pl = $false)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1___)

    #@btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sa_, $fe_x_sa_x_sc, $se_, $fe1___)

end
