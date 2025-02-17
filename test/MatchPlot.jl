using Random: seed!

using Statistics: cor

using Test: @test

using Omics

# ---- #

const U1 = U2 = 10

const U3 = 8

const ST = 3.0

const NU_ = rand(8)

const N1 = randn(U3 * 2, 8)

for (id, (nu_, N2, u1, u2, u3, st)) in enumerate((
    #
    (randn(4), randn(4, 4), U1, U2, 1, ST),
    (randn(4), randn(4, 4), U1, U2, 2, ST),
    (randn(4), randn(4, 4), U1, U2, 3, ST),
    #
    (randn(1000), randn(2, 1000), U1, U2, U3, ST),
    #
    (randn(1000), randn(100, 1000), 0, 0, U3, ST),
    (randn(1000), randn(100, 1000), U1, 0, U3, ST),
    (randn(1000), randn(100, 1000), 0, U2, U3, ST),
    (randn(1000), randn(100, 1000), U1, U2, U3, ST),
    #
    (NU_, N1, U1, U2, U3, 0.0),
    (NU_, N1, U1, U2, U3, 1.0),
    (NU_, N1, U1, U2, U3, 2.0),
    (NU_, N1, U1, U2, U3, ST),
    (NU_, N1, U1, U2, U3, 4.0),
    #
    (
        [1.4, 1.3, 0.2, 0.1],
        [
            1 1 0 0
            1 NaN 3 4
            0.5 0.5 0.5 0.5
            0.49 0.51 0.48 0.52
            1 2 NaN 4
            0 0 1 1
        ],
        U1,
        U2,
        U3,
        ST,
    ),
))

    a1_ = map(id -> "Feature $id", axes(N2, 1))

    a2_ = map(id -> "Sample $id", axes(N2, 2))

    R = Omics.Match.go(cor, nu_, N2; u1, u2)

    id_ = sortperm(R[:, 1])

    Omics.MatchPlot.writ(
        mkpath(joinpath(homedir(), "Downloads", string(id))),
        "Sample",
        a2_,
        "Target",
        nu_,
        "Feature",
        a1_[id_],
        N2[id_, :],
        R[id_, :];
        u1 = u3,
        st,
    )

end
