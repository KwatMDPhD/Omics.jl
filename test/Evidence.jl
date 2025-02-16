using Test: @test

using Omics

# ---- #

const PR = 0.5

const P1 = 0.75

const P2 = 0.25

# Center around 1.

P1 / PR

P2 / PR

# Is not symmetric.

log2(P1 / PR)

log2(P2 / PR)

# Is symmetric around 0.

log2(Omics.Probability.get_odd(PR))

log2(Omics.Probability.get_odd(P1) / Omics.Probability.get_odd(PR))

log2(Omics.Probability.get_odd(P2) / Omics.Probability.get_odd(PR))

# ---- #

const PR_ = PO_ = vcat(0.01, 0.1:0.1:0.9, 0.99)

const CO = Omics.Coloring.make(["#0000ff", "#ffffff", "#ff0000"])

Omics.Plot.plot(
    "",
    push!(
        map(
            pr -> Dict(
                "name" => "Prior = $pr",
                "y" => map(po -> Omics.Evidence.ge(pr, po), PO_),
                "x" => PO_,
                "line" => Dict("color" => Omics.Color.hexify(CO[pr])),
            ),
            PR_,
        ),
    ),
    Dict(
        "yaxis" => Dict("title" => Dict("text" => "Evidence"), "zeroline" => true),
        "xaxis" => Dict("title" => Dict("text" => "Posterior")),
    ),
)

# ---- #

for (pr, po, ev) in (
    (0.0, 0.0, NaN),
    (1.0, 1.0, NaN),
    (0.0, 0.5, Inf),
    (0.0, 1.0, Inf),
    (1.0, 0.0, -Inf),
    (1.0, 0.5, -Inf),
    (0.5, 0.0, -Inf),
    (0.5, 0.5, 0.0),
    (0.5, 1.0, Inf),
    (2 / 3, 0.5, -0.9999999999999997),
    (1 / 3, 0.5, 1.0000000000000002),
)

    @test Omics.Evidence.ge(pr, po) === ev

    if isfinite(ev)

        @test Omics.Evidence.get_posterior_probability(pr, ev) === po

    end

end

# ---- #

# 7.125 ns (0 allocations: 0 bytes)
# 14.028 ns (0 allocations: 0 bytes)

for po_ in ([0.5], [0.4, 0.6])

    @test isapprox(Omics.Evidence.ge(0.5, po_), 0.0; atol = 1e-15)

    #@btime Omics.Evidence.ge(0.5, $po_)

end

# ---- #

Omics.Evidence.plot(
    "",
    0.6,
    ("Feature 1", "Feature 2", "Feature 3", "Feature 4", "Feature 5"),
    (0.5, 0.6, 0.7, nothing, nothing);
    p2_ = (0.4, 0.3, 0.2, 0.1, 0.01),
    p3_ = (0.6, 0.7, 0.8, 0.9, 0.99),
    la = Dict("title" => Dict("text" => "Target")),
)

# ---- #

for um in 0:8

    Omics.Evidence.plot("", 0.48, map(id -> "Feature $id", 1:um), rand(um))

end
