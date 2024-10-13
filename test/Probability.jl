using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for (Pr, re) in (
    (0, 0.0),
    (0.01, 0.010101010101010102),
    (0.2, 0.25),
    (1 / 3, 0.49999999999999994),
    (0.5, 1.0),
    (2 / 3, 1.9999999999999998),
    (0.8, 4.000000000000001),
    (0.99, 98.99999999999991),
    (1, Inf),
)

    @test Omics.Probability.get_odd(Pr) === re

end

const Pr_ = 0:0.1:1

Omics.Plot.plot(
    "",
    (Dict("y" => map(Omics.Probability.get_odd, Pr_), "x" => Pr_),),
    Dict(
        "yaxis" => Dict("title" => Dict("text" => "Odd")),
        "xaxis" => Dict("title" => Dict("text" => "Probability")),
    ),
)

# ---- #

for (lo, re) in
    ((-Inf, 0.0), (-2, 0.2), (-1, 1 / 3), (0, 0.5), (1, 2 / 3), (2, 0.8), (Inf, NaN))

    @test Omics.Probability.get_probability(lo) === re

end
