using DataFrames

include("_.jl")

# --------------------------------------------- #

TE = joinpath(tempdir(), "BioLab.test.FeatureSetEnrichment")

BioLab.Path.empty(TE)

# --------------------------------------------- #

sc_ = [-2.0, -1, 0, 0, 1, 2]

id = 1

for (ex, re) in ((-1.0, 0.5), (1.0, 2.0), (2.0, 4.0), (3.0, 8.0))

    BioLab.print_header(ex)

    @test BioLab.FeatureSetEnrichment._get_absolute_raise(sc_, id, ex) == re

    # @code_warntype BioLab.FeatureSetEnrichment._get_absolute_raise(sc_, id, ex)

    # 16.784 ns (0 allocations: 0 bytes)
    # 2.458 ns (0 allocations: 0 bytes)
    # 16.784 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # @btime BioLab.FeatureSetEnrichment._get_absolute_raise($sc_, $id, $ex)

end

# --------------------------------------------- #

sc_ = [-2.0, -1, 0, 0, 1, 2]

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

sc_ = [-2.0, -1, 0, 0, 1, 2]

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
    ["Law", "Black Beard"],
    [1.0, -1.0],
    [true, true],
    [0.1, -0.1],
    11.29,
)

# @code_warntype BioLab.FeatureSetEnrichment._plot_mountain(
#     ["Law", "Black Beard"],
#     [1.0, -1.0],
#     [true, true],
#     [0.1, -0.1],
#     11.29;
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

    display(
        BioLab.FeatureSetEnrichment.enrich(
            al,
            fe_,
            sc_,
            fe1_;
            title_text = string(al),
            ht = joinpath(TE, "mountain.$al.html"),
        ),
    )

end

# --------------------------------------------- #

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_myc()

bo_ = BioLab.Collection.is_in(fe_, fe1_)

# --------------------------------------------- #

for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

    display(
        BioLab.FeatureSetEnrichment._enrich(
            al,
            fe_,
            sc_,
            bo_;
            title_text = BioLab.String.split_and_get(string(al), '.', 3)[1:(end - 2)],
            lo = "Low Phenotype",
            hi = "High Phenotype",
        ),
    )

end

# --------------------------------------------- #

feature_x_sample_x_score = DataFrame(
    "Feature" => fe_,
    "Score" => sc_,
    "Score x 10" => sc_ * 10.0,
    "Constant" => fill(0.8, length(fe_)),
)

se_fe1_ =
    BioLab.GMT.read(joinpath(@__DIR__, "FeatureSetEnrichment.data", "h.all.v7.1.symbols.gmt"))

se_ = collect(keys(se_fe1_))

fe1___ = collect(values(se_fe1_))

# --------------------------------------------- #

for al in (
    BioLab.FeatureSetEnrichment.KS(),
    BioLab.FeatureSetEnrichment.KLi(),
    BioLab.FeatureSetEnrichment.KLioM(),
)

    BioLab.print_header(al)

    # 45.583 μs (0 allocations: 0 bytes)
    # 220.875 μs (0 allocations: 0 bytes)
    # 364.458 μs (0 allocations: 0 bytes)
    # @btime BioLab.FeatureSetEnrichment._enrich($al, $fe_, $sc_, $bo_; pl = $false)

    # 570.000 μs (9 allocations: 20.80 KiB)
    # 745.625 μs (9 allocations: 20.80 KiB)
    # 891.041 μs (9 allocations: 20.80 KiB)
    # @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1_; pl = $false)

    # 3.240 ms (108 allocations: 1.49 MiB)
    # 12.069 ms (108 allocations: 1.49 MiB)
    # 19.324 ms (108 allocations: 1.49 MiB)
    # @btime BioLab.FeatureSetEnrichment.enrich($al, $fe_, $sc_, $fe1___)

    # # 11.463 ms (463 allocations: 8.66 MiB)
    # # 37.931 ms (463 allocations: 8.66 MiB)
    # # 59.793 ms (463 allocations: 8.66 MiB)
    # @btime BioLab.FeatureSetEnrichment.enrich($al, $feature_x_sample_x_score, $se_, $fe1___)

end
