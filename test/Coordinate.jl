using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

for (di, re1, re2) in (
    (
        [
            0 1 2
            1 0 3
            2 3 0
        ],
        [
            -0.323051  -1.31159     1.63464
            0.300953  -0.0234223  -0.277531
        ],
        [
            -0.323051  -1.31159     1.63464   -0.81732    0.161526  0.655795   -2.98023e-8  -2.98023e-8  -2.98023e-8
             0.300953  -0.0234223  -0.277531   0.138765  -0.150476  0.0117112  -5.58794e-9  -5.58794e-9  -5.58794e-9
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
        [
            0.0827895  -0.535622   0.452832  -0.226416  -0.0413947  0.267811  1.73847e-8  1.73847e-8  1.73847e-8
            0.57286    -0.219652  -0.353208   0.176604  -0.28643    0.109826  9.93411e-9  9.93411e-9  9.93411e-9
        ],
    ),
)

    # 2.583 μs (75 allocations: 4.00 KiB)
    # 222.685 ns (3 allocations: 592 bytes)
    # 308.402 ns (3 allocations: 592 bytes)
    # 3.917 μs (111 allocations: 5.92 KiB)
    # 222.456 ns (3 allocations: 592 bytes)
    # 307.979 ns (3 allocations: 592 bytes)

    seed!(20231210)

    dn = Nucleus.Coordinate.get(di)

    @test isapprox(dn, re1; atol = 1e-5)

    #@btime Nucleus.Coordinate.get($di)

    np = [
        1 0 0 1 0 1 1 0.5 2
        0 1 0 1 1 0 1 0.5 2
        0 0 1 0 1 1 1 0.5 2
    ]

    @test isapprox(Nucleus.Coordinate.pull(dn, np), re2; atol = 1e-5)

    for pu in (1, 2)

        #@btime Nucleus.Coordinate.pull($dn, $np, $pu)

    end

end

# ---- #

const CO = [
    -1.0 -1 1 1
    1 -1 -1 1
]

# ---- #

const TR = Nucleus.Coordinate.triangulate(eachcol(CO))

# ---- #

# 9.791 μs (154 allocations: 18.67 KiB)
#@btime Nucleus.Coordinate.triangulate(eachcol(CO));

# ---- #

const VP = Nucleus.Coordinate.wall(TR)

# ---- #

# 325.000 ns (6 allocations: 1.28 KiB)
#@btime Nucleus.Coordinate.wall(TR);

# ---- #

for co_ in eachcol(CO)

    @test Nucleus.Coordinate.is_in(co_, VP)

    # 9.510 ns (0 allocations: 0 bytes)
    # 9.510 ns (0 allocations: 0 bytes)
    # 9.510 ns (0 allocations: 0 bytes)
    # 9.541 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Coordinate.is_in($co_, VP)

end
