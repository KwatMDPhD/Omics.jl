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

for (de, re) in (([1.0, 2, 3, 4], [0.1, 0.2, 0.3, 0.4]),)

    @test Omics.Probability.ge(de) == re

    # 8.083 ns (0 allocations: 0 bytes)
    #@btime Omics.Probability.ge($de)

end

# ---- #

for (i1_, i2_, re) in ((
    [1, 2],
    [1, 2],
    [
        0.5 0
        0 0.5
    ],
),)

    jo = Omics.Probability.ge(i1_, i2_)

    @test jo == re

    @test isone(sum(jo))

    # 236.838 ns (12 allocations: 928 bytes)
    #@btime Omics.Probability.ge($i1_, $i2_)

end

# ---- #

# TODO: Get old testers

for (f1_, f2_) in (([1.0, 2], [1, 2]),)

    jo = Omics.Probability.ge(f1_, f2_; npoints = (2, 2))

    @test isone(sum(jo))

    # 837.584 μs (53 allocations: 2.51 MiB)
    #@btime Omics.Probability.ge($f1_, $f2_)

end

# ---- #

const JO = [
    1/8 1/16 1/16 1/4
    1/16 1/8 1/16 0
    1/32 1/32 1/16 0
    1/32 1/32 1/16 0
]

for (ea, re) in
    ((eachrow, [1 / 2, 1 / 4, 1 / 8, 1 / 8]), (eachcol, [1 / 4, 1 / 4, 1 / 4, 1 / 4]))

    @test Omics.Probability.ge(ea, JO) == re

    # 21.941 ns (2 allocations: 96 bytes)
    # 21.021 ns (2 allocations: 96 bytes)
    #@btime Omics.Probability.ge($ea, JO)

end
