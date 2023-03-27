using DataFrames

include("_.jl")

# --------------------------------------------- #

te = joinpath(tempdir(), "BioLab.test.FeatureSetEnrichment")

BioLab.Path.empty(te)

# --------------------------------------------- #

sc_ = [-2.0, -1, 0, 0, 1, 2]

# --------------------------------------------- #

id = 1

for ex in (0.9, 1.0, 1.1, 2.0)

    BioLab.print_header(ex)

    # TODO: `@test`.
    println(BioLab.FeatureSetEnrichment._get_absolute_raise(sc_, id, ex))

    # @code_warntype BioLab.FeatureSetEnrichment._get_absolute_raise(sc_, id, ex)

    # 16.784 ns (0 allocations: 0 bytes)
    # 2.458 ns (0 allocations: 0 bytes)
    # 16.784 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # @btime BioLab.FeatureSetEnrichment._get_absolute_raise($sc_, $id, $ex)

end

# --------------------------------------------- #

bo_ = [true, true, false, true, false, true]

for (ex, re) in ((1.0, (6, 5.0, 2.0)), (2.0, (6, 9.0, 2.0)))

    BioLab.print_header(ex)

    @test BioLab.FeatureSetEnrichment._sum_1_and_0(sc_, bo_, ex) == re

    # @code_warntype BioLab.FeatureSetEnrichment._sum_1_and_0(sc_, bo_, ex)

    # 6.417 ns (0 allocations: 0 bytes)
    # 19.121 ns (0 allocations: 0 bytes)    
    # @btime BioLab.FeatureSetEnrichment._sum_1_and_0($sc_, $bo_, $ex)

end

# --------------------------------------------- #

for (ex, re) in ((1.0, (6, 6.0, 5.0)), (2.0, (6, 10.0, 9.0)))

    BioLab.print_header(ex)

    @test BioLab.FeatureSetEnrichment._sum_all_and_1(sc_, bo_, ex) == re

    # @code_warntype BioLab.FeatureSetEnrichment._sum_all_and_1(sc_, bo_, ex)

    # 7.791 ns (0 allocations: 0 bytes)
    # 22.233 ns (0 allocations: 0 bytes)
    # @btime BioLab.FeatureSetEnrichment._sum_all_and_1($sc_, $bo_, $ex)

end

# --------------------------------------------- #

BioLab.FeatureSetEnrichment._plot_mountain(
    ["Black Beard", "Law"],
    [-1.0, 1.0],
    [true, false],
    [-0.2, 0.1],
    1129;
    title_text = "Winner",
    fe = "Character",
    sc = "Power",
)

# @code_warntype BioLab.FeatureSetEnrichment._plot_mountain(
#     ["Black Beard", "Law"],
#     [-1.0, 1.0],
#     [true, false],
#     [-0.2, 0.1],
#     1129;
#     title_text = "Winner",
#     fe = "Character",
#     sc = "Power",
# )

# --------------------------------------------- #

ca1 = "A2K"

# TODO: `@test`.
display(BioLab.FeatureSetEnrichment.benchmark_card(ca1))

# @code_warntype BioLab.FeatureSetEnrichment.benchmark_card(ca1)

# 46.970 ns (2 allocations: 240 bytes)
# @btime BioLab.FeatureSetEnrichment.benchmark_card($ca1)

# --------------------------------------------- #

for (n, n1) in ((3, 2), (4, 2), (5, 3))

    BioLab.print_header("$n $n1")

    # TODO: `@test`.
    display(BioLab.FeatureSetEnrichment.benchmark_random(n, n1))

    # @code_warntype BioLab.FeatureSetEnrichment.benchmark_random(n, n1)

    # 1.083 μs (30 allocations: 1.81 KiB)
    # 1.142 μs (34 allocations: 2.02 KiB)    
    # 1.312 μs (41 allocations: 2.47 KiB)    
    # @btime BioLab.FeatureSetEnrichment.benchmark_random($n, $n1)

end

# --------------------------------------------- #

# TODO: `@test`.
display(BioLab.FeatureSetEnrichment.benchmark_myc())

# @code_warntype BioLab.FeatureSetEnrichment.benchmark_myc()

# 34.414 ms (580131 allocations: 96.05 MiB)
# @btime BioLab.FeatureSetEnrichment.benchmark_myc()

# --------------------------------------------- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_card("AK")

for al in (BioLab.FeatureSetEnrichment.KS(), BioLab.FeatureSetEnrichment.KLioM())

    BioLab.FeatureSetEnrichment.score_set(
        al,
        fe_,
        sc_,
        fe1_;
        title_text = string(al),
        ht = joinpath(te, "mountain.$al.html"),
    )

end

# --------------------------------------------- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_myc()

bo_ = BioLab.Collection.is_in(fe_, fe1_)

fe_x_sa_x_sc = DataFrame(
    "Feature" => fe_,
    "Score" => sc_,
    "Score x 10" => sc_ * 10.0,
    "Constant" => fill(0.8, length(fe_)),
)

se_fe_ = BioLab.GMT.read(joinpath(@__DIR__, "FeatureSetEnrichment.data", "h.all.v7.1.symbols.gmt"))

# --------------------------------------------- #

al = BioLab.FeatureSetEnrichment.KS()

BioLab.FeatureSetEnrichment._score_set(al, fe_, sc_, bo_; title_text = "MYC Gene Set")

# 45.584 μs (0 allocations: 0 bytes)
# @btime BioLab.FeatureSetEnrichment._score_set($al, $fe_, $sc_, $bo_; pl = $false)

# 331.875 μs (6 allocations: 19.95 KiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_, $sc_, $bo_; pl = $false)

# 3.240 ms (114 allocations: 1.50 MiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_, $sc_, $se_fe_)

# 11.463 ms (489 allocations: 8.62 MiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_x_sa_x_sc, $se_fe_)

# --------------------------------------------- #

al = BioLab.FeatureSetEnrichment.KLi()

# 222.208 μs (0 allocations: 0 bytes)
# @btime BioLab.FeatureSetEnrichment._score_set($al, $fe_, $sc_, $bo_; pl = $false)

# 745.625 μs (9 allocations: 20.80 KiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_, $sc_, $fe1_; pl = $false)

# 12.131 ms (114 allocations: 1.50 MiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_, $sc_, $se_fe_)

# 38.171 ms (489 allocations: 8.62 MiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_x_sa_x_sc, $se_fe_)

# --------------------------------------------- #

al = BioLab.FeatureSetEnrichment.KLioM()

# 364.458 μs (0 allocations: 0 bytes)
# @btime BioLab.FeatureSetEnrichment._score_set($al, $fe_, $sc_, $bo_; pl = $false)

# 891.125 μs (9 allocations: 20.80 KiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_, $sc_, $fe1_; pl = $false)

# 19.248 ms (114 allocations: 1.50 MiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_, $sc_, $se_fe_)

# 59.793 ms (489 allocations: 8.62 MiB)
# @btime BioLab.FeatureSetEnrichment.score_set($al, $fe_x_sa_x_sc, $se_fe_)
