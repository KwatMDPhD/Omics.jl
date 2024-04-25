using Test: @test

using Nucleus

# ---- #

using DelaunayTriangulation: triangulate

using Random: seed!

# ---- #

for (aa, re) in (
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

    ca = Nucleus.Coordinate.get_cartesian(aa)

    @test isapprox(ca, re; atol = 1e-5)

    # 9.514 μs (292 allocations: 15.47 KiB)
    # 5.326 μs (165 allocations: 8.84 KiB)
    #@btime Nucleus.Coordinate.get_cartesian($aa) setup = seed!(20231210)

end

# ---- #

const CA = [
    -1.0 -1 1 1
    1 -1 -1 1
]

# ---- #

const TR = triangulate(eachcol(CA))

# ---- #

# 13.834 μs (305 allocations: 39.22 KiB)
#@btime triangulate(eachcol(CA));

# ---- #

const VP = Nucleus.Coordinate.wall(TR)

# ---- #

# 339.450 ns (6 allocations: 1.28 KiB)
#@btime Nucleus.Coordinate.wall(TR);

# ---- #

for yx in eachcol(CA)

    @test Nucleus.Coordinate.is_in(yx, VP)

    # 9.175 ns (0 allocations: 0 bytes)
    # 9.175 ns (0 allocations: 0 bytes)
    # 9.175 ns (0 allocations: 0 bytes)
    # 9.175 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Coordinate.is_in($yx, VP)

end

# ---- #

const AA = [
    0 1 2 3 4 5
    1 0 3 4 5 6
    2 3 0 5 6 7
    3 4 5 0 7 8
    4 5 6 7 0 9
    5 6 7 8 9 0.0
]

# ---- #

seed!(20240423)

# ---- #

const AN_ = Nucleus.Coordinate.get_polar(AA)

# ---- #

@test AN_ == [
    3.227306766493292,
    3.225656618311293,
    3.561874485774487,
    2.6924753975885922,
    4.726053584536512,
    1.2984595170912603,
]

# ---- #

# 66.875 μs (6 allocations: 640 bytes)
#@btime Nucleus.Coordinate.get_polar(AA) setup = seed!(20240423);

# ---- #

PA = Nucleus.Coordinate.make_unit(AN_)

# ---- #

@test PA[1, :] == AN_

# ---- #

@test PA[2, :] == ones(lastindex(AN_))

# ---- #

# 29.439 ns (1 allocation: 160 bytes)
#@btime Nucleus.Coordinate.make_unit(AN_);

# ---- #

for (xc, yc, re) in ((1, 1, 1 / 3), (-1, 1, 2 / 3), (-1, -1, 4 / 3), (1, -1, 5 / 3))

    yc = yc * sqrt(3)

    an, ra = Nucleus.Coordinate.convert_cartesian_to_polar(yc, xc)

    @test isapprox(an, pi * re)

    @test isapprox(ra, 2)

    y2, x2 = Nucleus.Coordinate.convert_polar_to_cartesian(an, ra)

    @test isapprox(y2, yc)

    @test isapprox(x2, xc)

    # 10.427 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)
    # 10.427 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)
    # 10.426 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)
    # 10.427 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)

    #@btime Nucleus.Coordinate.convert_cartesian_to_polar($yc, $xc)

    #@btime Nucleus.Coordinate.convert_polar_to_cartesian($an, $ra)

end

# ---- #

@test isapprox(
    PA,
    Nucleus.Coordinate.convert_cartesian_to_polar(
        Nucleus.Coordinate.convert_polar_to_cartesian(PA),
    ),
)

# ---- #

# 143.864 ns (2 allocations: 320 bytes)
#@btime Nucleus.Coordinate.convert_cartesian_to_polar(
#    Nucleus.Coordinate.convert_polar_to_cartesian(PA),
#);
