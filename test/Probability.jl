using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

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
    (1, Inf),
)

    @test Omics.Probability.get_odd(pr) === od

    if isfinite(od)

        @test Omics.Probability.ge(od) === pr

    end

end

# ---- #

const PR_ = 0:0.1:1

const OD_ = map(Omics.Probability.get_odd, PR_)

Omics.Plot.plot(
    "",
    (
        Dict(
            "showlegend" => false,
            "y" => (0, 1),
            "x" => (0, 1),
            "mode" => "lines",
            "line" => Dict("width" => 1, "color" => "#000000"),
        ),
        Dict("name" => "Odd", "y" => OD_, "x" => PR_),
        Dict("name" => "Log2(Odd)", "y" => map(log2, OD_), "x" => PR_),
    ),
    Dict(
        "yaxis" => Dict("zeroline" => true),
        "xaxis" => Dict("title" => Dict("text" => "Probability")),
    ),
)

# ---- #

# TODO
Omics.Probability.ge
