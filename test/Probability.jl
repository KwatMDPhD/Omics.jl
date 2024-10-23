using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

# 2.083 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
# 2.084 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.083 ns (0 allocations: 0 bytes)
# 2.125 ns (0 allocations: 0 bytes)
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

    #@btime Omics.Probability.get_odd($pr)

    if isfinite(od)

        @test Omics.Probability.ge(od) === pr

        #@btime Omics.Probability.ge($od)

    end

end

# ---- #

const PR_ = 0:0.1:1

const OD_ = map(Omics.Probability.get_odd, PR_)

Omics.Plot.plot(
    "",
    (
        Dict("name" => "Probability", "y" => (0, 1), "x" => (0, 1)),
        Dict("name" => "Odd", "y" => OD_, "x" => PR_),
        Dict("name" => "Log2(Odd)", "y" => map(log2, OD_), "x" => PR_),
    ),
    Dict("xaxis" => Dict("title" => Dict("text" => "Probability"))),
)
