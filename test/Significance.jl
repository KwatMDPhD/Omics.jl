include("environment.jl")

# ---- #

for po in 0:5

    n = 10^po

    nu_ = randn(n)

    # TODO: Test.
    BioLab.Significance.get_margin_of_error(nu_)

end

# ---- #

ra_ = collect(1:10)

@test BioLab.Significance._get_p_value(0, ra_) == BioLab.Significance._get_p_value(1, ra_) == 0.1

# ---- #

n = 2

@test BioLab.Significance._get_p_value(n, ra_) == 0.2

# ---- #

n_ = (1, 2, 9, 10)

re_ = (0.1, 0.2, 0.9, 1)

# ---- #

for (va, re) in zip(n_, re_)

    @test BioLab.Significance.get_p_value_for_less(va, ra_) == re

end

# ---- #

for (va, re) in zip(n_, reverse(re_))

    @test BioLab.Significance.get_p_value_for_more(va, ra_) == re

end

# ---- #

pv1_ = [0.001, 0.01, 0.03, 0.5]

n_ = (length(pv1_), 40, 100, 1000)

for n in n_

    # TODO: Test.
    BioLab.Significance.adjust_p_value_with_bonferroni(pv1_, n)

    # TODO: Test.
    BioLab.Significance.adjust_p_value_with_benjamini_hochberg(pv1_, n)

end

# ---- #

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

# ---- #

nu_ = [0, 1, 8, 9]

ra_ = collect(0:9)

# ---- #

@test BioLab.Significance.get_p_value_adjust(BioLab.Significance.get_p_value_for_less, nu_, ra_) ==
      ([0.1, 0.2, 0.9, 1], [0.4, 0.4, 1, 1])

# ---- #

@test BioLab.Significance.get_p_value_adjust(BioLab.Significance.get_p_value_for_more, nu_, ra_) ==
      ([1, 0.9, 0.2, 0.1], [1, 1, 0.4, 0.4])

# ---- #

@test BioLab.Significance.get_p_value_adjust(nu_, ra_) ==
      ([0.1, 0.2, 0.2, 0.1], [0.4, 0.4, 0.4, 0.4])
