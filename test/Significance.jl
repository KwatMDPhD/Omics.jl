using Test: @test

# ---- #

for (po, re) in zip(
    0:5,
    (
        NaN,
        0.6189908521765288,
        0.1900545163940193,
        0.06362492851958153,
        0.019426335022525613,
        0.00620269175436949,
    ),
)

    Random.seed!(20230612)

    @test isequal(BioLab.Significance.get_margin_of_error(randn(10^po)), re)

end

# ---- #

ra_ = collect(1:10)

@test BioLab.Significance._get_p_value(0, ra_) == BioLab.Significance._get_p_value(1, ra_) == 0.1

# ---- #

n = 2

@test BioLab.Significance._get_p_value(n, ra_) == 0.2

# ---- #

nu_ = (1, 2, 9, 10)

re_ = (0.1, 0.2, 0.9, 1)

# ---- #

for (nu, re) in zip(nu_, re_)

    @test BioLab.Significance.get_p_value_for_less(nu, ra_) == re

end

# ---- #

for (nu, re) in zip(nu_, reverse(re_))

    @test BioLab.Significance.get_p_value_for_more(nu, ra_) == re

end

# ---- #

@test all(
    isapprox(pv, re; atol = 0.01) for (pv, re) in zip(
        BioLab.Significance.adjust_p_value([
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

for (fu, re) in (
    (BioLab.Significance.get_p_value_for_less, ([0.1, 0.2, 0.9, 1], [0.4, 0.4, 1, 1])),
    (BioLab.Significance.get_p_value_for_more, ([1, 0.9, 0.2, 0.1], [1, 1, 0.4, 0.4])),
)

    @test BioLab.Significance.get_p_value_adjust(fu, nu_, ra_) == re

end

# ---- #

@test BioLab.Significance.get_p_value_adjust(nu_, ra_) ==
      ([0.1, 0.2, 0.2, 0.1], [0.4, 0.4, 0.4, 0.4])
