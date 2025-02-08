using Random: seed!

using Test: @test

using Omics

# ---- #

for (di, re) in (
    (
        [
            0 1 2
            1 0 3
            2 3 0
        ],
        [
            -0.323051 -1.31159 1.63464
            0.300953 -0.0234223 -0.277531
        ],
    ),
    (
        [
            0 1 1
            1 0 1
            1 1 0
        ],
        [
            0.0827895 -0.5356215 0.45283207
            0.5728598 -0.219652 -0.3532078
        ],
    ),
)

    seed!(20231210)

    @test isapprox(Omics.Coordinate.get_cartesian(di), re; atol = 1e-5)

end

# ---- #

# 71.417 μs (6 allocations: 560 bytes)

for (di, re) in ((
    [
        0 1 2 3 4 5
        1 0 3 4 5 6
        2 3 0 5 6 7
        3 4 5 0 7 8
        4 5 6 7 0 9
        5 6 7 8 9 0.0
    ],
    [
        5.869485802601142,
        5.879259541653078,
        6.189365973376273,
        5.292574117369777,
        4.243083607790291,
        1.4567216544520305,
    ],
),)

    ui = 1000

    ut = 1 + ui

    co_ = Vector{Float64}(undef, ut)

    te_ = Vector{Float64}(undef, ut)

    pr_ = Vector{Float64}(undef, ut)

    ac_ = BitVector(undef, ut)

    seed!(20240423)

    an_ = Omics.Coordinate.get_polar!(di; ui, co_, te_, pr_, ac_)

    @test isapprox(an_, re)

    #@btime Omics.Coordinate.get_polar!($di)

    Omics.Coordinate.plot("", co_, te_, clamp!(pr_, 0.0, 1.0), ac_)

end
