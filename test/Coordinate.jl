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
        4.613493863132031,
        4.623988611262445,
        4.289663707024984,
        5.190467066616274,
        3.122061514443475,
        0.32751146228354094,
    ],
),)

    ui = 2000

    ut = 1 + ui

    co_ = Vector{Float64}(undef, ut)

    te_ = Vector{Float64}(undef, ut)

    pr_ = Vector{Float64}(undef, ut)

    ac_ = BitVector(undef, ut)

    seed!(20240423)

    an_ = Omics.Coordinate.get_polar!(di; ui, co_, te_, pr_, ac_)

    Omics.Coordinate.plot("", co_, te_, pr_, ac_)

    @test isapprox(an_, re)

    # 200.000 μs (6 allocations: 560 bytes)
    #@btime Omics.Coordinate.get_polar!($di)

end
