using Test: @test

using Omics

# ---- #

for (pr, od) in (
    (0.0, 0.0),
    (0.01, 0.010101010101010102),
    (0.2, 0.25),
    (1 / 3, 0.49999999999999994),
    (0.5, 1.0),
    (2 / 3, 1.9999999999999998),
    (0.8, 4.000000000000001),
    (0.99, 98.99999999999991),
    (1.0, Inf),
)

    @test Omics.Probability.get_odd(pr) === od

    if isfinite(od)

        @test Omics.Probability.ge(od) === pr

    end

end

# ---- #

for (nu, re) in ((-32, 1.2664165549094015e-14), (0, 0.5), (32, 0.9999999999999873))

    @test Omics.Probability.get_logistic(nu) === re

end

# ---- #

const PR_ = 0.0:0.1:1.0

# ---- #

const OD_ = map(Omics.Probability.get_odd, PR_)

Omics.Plot.plot(
    "",
    (
        Dict("name" => "Odd", "y" => OD_, "x" => PR_),
        Dict("name" => "Log2(Odd) (Evidence)", "y" => map(log2, OD_), "x" => PR_),
    ),
    Dict("xaxis" => Dict("title" => Dict("text" => "Probability"))),
)

# ---- #

Omics.Plot.plot(
    "",
    map(
        nu_ -> Dict(
            "name" => "$(nu_[1]) ... $(nu_[end])",
            "y" => map(Omics.Probability.get_logistic, nu_),
            "x" => nu_,
            "mode" => "markers",
        ),
        (-10:10, -1.0:0.1:1.0, PR_),
    ),
    Dict("yaxis" => Dict("title" => Dict("text" => "Probability"))),
)
