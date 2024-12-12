using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

# 3.041 ns (0 allocations: 0 bytes)
# 3.041 ns (0 allocations: 0 bytes)
# 3.625 ns (0 allocations: 0 bytes)
# 3.625 ns (0 allocations: 0 bytes)
# 3.375 ns (0 allocations: 0 bytes)
# 3.333 ns (0 allocations: 0 bytes)
# 3.333 ns (0 allocations: 0 bytes)
# 5.125 ns (0 allocations: 0 bytes)
# 4.583 ns (0 allocations: 0 bytes)
# 3.666 ns (0 allocations: 0 bytes)
# 6.458 ns (0 allocations: 0 bytes)
# 4.583 ns (0 allocations: 0 bytes)
# 6.458 ns (0 allocations: 0 bytes)
# 4.583 ns (0 allocations: 0 bytes)
for (pr, po, ev) in (
    # 0 / 0
    (0, 0, NaN),
    # Inf / Inf
    (1, 1, NaN),
    # 1 / 0
    (0, 0.5, Inf),
    # Inf / 0
    (0, 1, Inf),
    # 0 / Inf
    (1, 0, -Inf),
    # 1 / Inf
    (1, 0.5, -Inf),
    # 0 / 1
    (0.5, 0, -Inf),
    # 1 / 1
    (0.5, 0.5, 0.0),
    # Inf / 1
    (0.5, 1, Inf),
    # 1 / 2
    (2 / 3, 0.5, -0.9999999999999997),
    # 1 / 0.5 
    (1 / 3, 0.5, 1.0000000000000002),
)

    @test Omics.Evidence.ge(pr, po) === ev

    #@btime Omics.Evidence.ge($pr, $po)

    if isfinite(ev)

        @test Omics.Evidence.get_posterior_probability(pr, ev) === po

        #@btime Omics.Evidence.get_posterior_probability($pr, $ev)

    end

end

# ---- #

for po_ in ((0.5,), (0.4, 0.6))

    @test isapprox(Omics.Evidence.ge(0.5, po_), 0; atol = 1e-15)

end

# ---- #

const PR_ = PO_ = 0:0.1:1

Omics.Plot.plot(
    "",
    [
        Dict(
            "name" => "Prior Probability = $pr",
            "y" => map(po -> Omics.Evidence.ge(pr, po), PO_),
            "x" => PO_,
        ) for pr in PR_
    ],
    Dict(
        "yaxis" => Dict("title" => Dict("text" => "Evidence"), "zeroline" => true),
        "xaxis" => Dict("title" => Dict("text" => "Posterior Probability")),
    ),
)

# ---- #

Omics.Evidence.plot(
    "",
    "Target",
    0.6,
    ("Feature 1 = 0.4", "Feature 2 = 0.6", "Feature 3 = 0.8", "Feature 4", "Feature 5"),
    (0.4, 0.6, 0.8, NaN, NaN),
    false,
)

# ---- #

for uf in 1:8

    Omics.Evidence.plot(
        "",
        "Target",
        0.4,
        ["Feature $id = 1.234" for id in 1:uf],
        rand(uf),
        rand(Bool),
    )

end
