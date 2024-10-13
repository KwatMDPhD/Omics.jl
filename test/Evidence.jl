using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for (p1, p1f, re) in (
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

    @test Omics.Evidence.get_evidence(p1, p1f) === re

end

# ---- #

const P1_ = P1F_ = 0:0.1:1

Omics.Plot.plot(
    "",
    [
        Dict(
            "name" => "Prior = $p1",
            "y" => map(p1f -> Omics.Evidence.get_evidence(p1, p1f), P1F_),
            "x" => P1F_,
        ) for p1 in P1_
    ],
    Dict(
        "yaxis" => Dict("title" => Dict("text" => "Evidence"), "zeroline" => true),
        "xaxis" => Dict("title" => Dict("text" => "Posterior Probability")),
    ),
)

# ---- #

for (ta_, fe_, p1f_) in (
    ([0, 0, 0, 1, 1, 1], [0, 0, 0, 2, 2, 2], [0, 0, 0, 1, 1, 1]),
    ([1, 1, 1, 0, 0, 0], [2, 2, 2, 0, 0, 0], [1, 1, 1, 0, 0, 0]),
    ([0, 1, 0, 1, 0, 1], [0, 2, 0, 2, 0, 2], [0, 1, 0, 1, 0, 1]),
    ([0, 0, 0, 1, 1, 1], [2, 2, 2, 0, 0, 0], [0, 0, 0, 1, 1, 1]),
    ([1, 1, 1, 0, 0, 0], [0, 0, 0, 2, 2, 2], [1, 1, 1, 0, 0, 0]),
    ([0, 1, 0, 1, 0, 1], [2, 0, 2, 0, 2, 0], [0, 1, 0, 1, 0, 1]),
)

    Omics.Evidence.plot(
        "",
        "Sample",
        map(id -> "_$id", eachindex(ta_)),
        "Target",
        ta_,
        "Feature",
        fe_,
        p1f_,
        map(nu -> nu - 0.1, p1f_),
        map(nu -> nu + 0.1, p1f_);
        si = 24,
    )

end

# ---- #

for uf in 1:8

    Omics.Evidence.plot("", "Target", 0.4, ["Feature $id = 1.234" for id in 1:uf], rand(uf))

end

# ---- #

Omics.Evidence.plot(
    "",
    "Something",
    0.6,
    ("Aa = 0.5", "Bb = 0.6", "Cc = 0.7", "Dd = 0.8", "Ee = 0.9"),
    (0.5, 0.6, 0.7, 0.8, 0.9),
)
