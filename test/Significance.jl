include("_.jl")

for po in 0:5

    n = 10^po

    BioLab.print_header(n)

    nu_ = randn(n)

    # TODO: `@test`.
    println(BioLab.Significance.get_margin_of_error(nu_))

    # @code_warntype BioLab.Significance.get_margin_of_error(nu_)

    # 38.469 ns (0 allocations: 0 bytes)
    # 43.851 ns (0 allocations: 0 bytes)
    # 72.997 ns (0 allocations: 0 bytes)
    # 535.275 ns (0 allocations: 0 bytes)
    # 3.963 μs (0 allocations: 0 bytes)
    # 40.541 μs (0 allocations: 0 bytes)
    # @btime BioLab.Significance.get_margin_of_error($nu_)

end

ra_ = collect(1:10)

@test BioLab.Significance._get_p_value(0, ra_) == BioLab.Significance._get_p_value(1, ra_) == 0.1

n = 2

@test BioLab.Significance._get_p_value(n, ra_) == 0.2

# @code_warntype BioLab.Significance._get_p_value(n, ra_)

# 2.083 ns (0 allocations: 0 bytes)
# @btime BioLab.Significance._get_p_value($n, $ra_)

n_ = (1, 2, 9, 10)

re_ = (0.1, 0.2, 0.9, 1.0)

for (va, re) in zip(n_, re_)

    BioLab.print_header(va)

    @test BioLab.Significance.get_p_value_for_less(va, ra_) == re

    # @code_warntype BioLab.Significance.get_p_value_for_less(va, ra_)

    # 4.583 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # 4.625 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # @btime BioLab.Significance.get_p_value_for_less($va, $ra_)

end

for (va, re) in zip(n_, reverse(re_))

    BioLab.print_header(va)

    @test BioLab.Significance.get_p_value_for_more(va, ra_) == re

    # @code_warntype BioLab.Significance.get_p_value_for_more(va, ra_)

    # 4.584 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # 4.583 ns (0 allocations: 0 bytes)
    # @btime BioLab.Significance.get_p_value_for_more($va, $ra_)

end

pv1_ = [0.001, 0.01, 0.03, 0.5]

n_ = (length(pv1_), 40, 100, 1000)

pv2_ = [10^-3, 10^-2, 10^-1, 10^0]

for n in n_

    println(BioLab.Significance.adjust_p_value_with_bonferroni(pv1_, n))

end

# TODO: `@test`.

# @code_warntype BioLab.Significance.adjust_p_value_with_bonferroni(pv2_)

# 35.917 ns (1 allocation: 96 bytes)
# @btime BioLab.Significance.adjust_p_value_with_bonferroni($pv2_)

for n in n_

    println(BioLab.Significance.adjust_p_value_with_benjamini_hochberg(pv1_, n))

end

@test all(
    isapprox(pv, re; atol = 0.01) for (pv, re) in zip(
        BioLab.Significance.adjust_p_value_with_benjamini_hochberg([
            0.005,
            0.009,
            0.019,
            0.022,
            0.051,
            0.101,
            0.361,
            0.387,
        ]),
        (0.036, 0.036, 0.044, 0.044, 0.082, 0.135, 0.387, 0.387),
    )
)

# @code_warntype BioLab.Significance.adjust_p_value_with_benjamini_hochberg(pv2_)

# 483.680 ns (6 allocations: 416 bytes)
# @btime BioLab.Significance.adjust_p_value_with_benjamini_hochberg($pv2_)

nu_ = [0.0, 1, 8, 9]

ra_ = collect(0.0:9)

BioLab.print_header("Less")

@test BioLab.Significance.get_p_value_and_adjust(
    BioLab.Significance.get_p_value_for_less,
    nu_,
    ra_,
) == ([0.1, 0.2, 0.9, 1.0], [0.4, 0.4, 1.0, 1.0])

# @code_warntype BioLab.Significance.get_p_value_and_adjust(
#     BioLab.Significance.get_p_value_for_less,
#     nu_,
#     ra_,
# )

# 636.548 ns (8 allocations: 544 bytes)
# @btime BioLab.Significance.get_p_value_and_adjust(
#     $BioLab.Significance.get_p_value_for_less,
#     $nu_,
#     $ra_,
# )

BioLab.print_header("More")

@test BioLab.Significance.get_p_value_and_adjust(
    BioLab.Significance.get_p_value_for_more,
    nu_,
    ra_,
) == ([1.0, 0.9, 0.2, 0.1], [1.0, 1.0, 0.4, 0.4])

# @code_warntype BioLab.Significance.get_p_value_and_adjust(
#     BioLab.Significance.get_p_value_for_more,
#     nu_,
#     ra_,
# )

# 649.245 ns (8 allocations: 544 bytes)
# @btime BioLab.Significance.get_p_value_and_adjust(
#     $BioLab.Significance.get_p_value_for_more,
#     $nu_,
#     $ra_,
# )

BioLab.print_header("Less and More")

@test BioLab.Significance.get_p_value_and_adjust(nu_, ra_) ==
      ([0.1, 0.2, 0.2, 0.1], [0.4, 0.4, 0.4, 0.4])

# @code_warntype BioLab.Significance.get_p_value_and_adjust(nu_, ra_)

# 1.142 μs (16 allocations: 1.19 KiB)
# @btime BioLab.Significance.get_p_value_and_adjust($nu_, $ra_)
