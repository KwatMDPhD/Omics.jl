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
    (1.0, Inf),
)

    @test Omics.Probability.get_odd(pr) === od

    #@btime Omics.Probability.get_odd($pr)

    if isfinite(od)

        @test Omics.Probability.ge(od) === pr

        #@btime Omics.Probability.ge($od)

    end

end

# ---- #

const PR_ = 0.0:0.1:1.0

# ---- #

const OD_ = map(Omics.Probability.get_odd, PR_)

Omics.Plot.plot(
    "",
    (
        Dict("name" => "Odd", "y" => OD_, "x" => PR_),
        Dict("name" => "Log2(Odd)", "y" => map(log2, OD_), "x" => PR_),
    ),
    Dict("xaxis" => Dict("title" => Dict("text" => "Probability"))),
)

# ---- #

# 4.875 ns (0 allocations: 0 bytes)
for (nu, re) in ((0, 0.5),)

    @test Omics.Probability.get_logistic(nu) === re

    #@btime Omics.Probability.get_logistic($nu)

end

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
    Dict("yaxis" => Dict("title" => Dict("text" => "Logistic Probability"))),
)
