using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const PR_ = PO_ = vcat(0.01, 0.1:0.1:0.9, 0.99)

Omics.Plot.plot(
    "",
    vcat(
        [
            Dict(
                "name" => "Prior = $pr",
                "y" => map(po -> Omics.Evidence.ge(pr, po), PO_),
                "x" => PO_,
                "line" => Dict("color" => Omics.Palette.color(pr, Omics.Palette.bwr)),
            ) for pr in PR_
        ],
        Dict(
            "name" => "Prior = 1 - Posterior",
            "y" => map(po -> Omics.Evidence.ge(1.0 - po, po), PO_),
            "x" => PO_,
            "mode" => "markers",
            "marker" => Dict("size" => 16, "color" => Omics.Color.GR),
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
# 14.055 ns (0 allocations: 0 bytes)
for po_ in ([0.5], [0.4, 0.6])

    @test isapprox(Omics.Evidence.ge(0.5, po_), 0.0; atol = 1e-15)

    #@btime Omics.Evidence.ge(0.5, $po_)

end

# ---- #

Omics.Evidence.plot(
    "",
    "Target",
    0.6,
    (
        "Feature 1 = 0.5",
        "Feature 2 = 0.6 = Prior",
        "Feature 3 = 0.7",
        "Feature 4 = ?",
        "Feature 5 = ?",
    ),
    (0.5, 0.6, 0.7, nothing, nothing);
    pl_ = (0.59, 0.5, 0.4, 0.21, 0.01),
    pu_ = (0.61, 0.7, 0.8, 0.99, 0.99),
)

# ---- #

for uf in 1:8

    Omics.Evidence.plot("", "Target", 0.5, ["Feature $id = 1.234" for id in 1:uf], rand(uf))

end
