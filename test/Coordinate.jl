using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

for (an_x_an_x_di, re1, re2) in (
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

    # 2.750 μs (75 allocations: 4.00 KiB)
    # 217.565 ns (3 allocations: 592 bytes)
    # 218.073 ns (3 allocations: 592 bytes)
    # 3.933 μs (103 allocations: 5.46 KiB)
    # 216.888 ns (3 allocations: 592 bytes)
    # 216.732 ns (3 allocations: 592 bytes)

    seed!(20231210)

    di_x_no_x_co = Nucleus.Coordinate.get(an_x_an_x_di)

    @test isapprox(di_x_no_x_co, re1; atol = 1e-5)

    #@btime Nucleus.Coordinate.get($an_x_an_x_di)

    no_x_po_x_pu = [
        1 0 0 1 0 1 1 0.5 2
        0 1 0 1 1 0 1 0.5 2
        0 0 1 0 1 1 1 0.5 2
    ]

    di_x_po_x_co = Nucleus.Coordinate.pull(di_x_no_x_co, no_x_po_x_pu)

    @test isapprox(di_x_po_x_co, re2; atol = 1e-5)

    for pu in (1, 2)

        #@btime Nucleus.Coordinate.pull($di_x_no_x_co, $no_x_po_x_pu)

    end

end

# ---- #

const DI_X_AN_X_CO = [
    -1.0 -1 1 1
    1 -1 -1 1
]

# ---- #

const TR = Nucleus.Coordinate.triangulate(eachcol(DI_X_AN_X_CO))

# ---- #

# 9.791 μs (154 allocations: 18.67 KiB)
#@btime Nucleus.Coordinate.triangulate(eachcol(DI_X_AN_X_CO));

# ---- #

const VP = Nucleus.Coordinate.wall(TR)

# ---- #

# 373.780 ns (6 allocations: 1.28 KiB)
#@btime Nucleus.Coordinate.wall(TR);

# ---- #

for co_ in eachcol(DI_X_AN_X_CO)

    @test Nucleus.Coordinate.is_in(co_, VP)

    # 9.510 ns (0 allocations: 0 bytes)
    # 9.541 ns (0 allocations: 0 bytes)
    # 9.551 ns (0 allocations: 0 bytes)
    # 9.541 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Coordinate.is_in($co_, VP)

end
