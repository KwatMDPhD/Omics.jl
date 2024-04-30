using Test: @test

using Nucleus

# ---- #

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

const AA = [
    0 1 2 3 4 5
    1 0 3 4 5 6
    2 3 0 5 6 7
    3 4 5 0 7 8
    4 5 6 7 0 9
    5 6 7 8 9 0.0
]

# ---- #

seed!(20240425)

const CA = Nucleus.Coordinate.get_cartesian(AA)

# ---- #

seed!(20240423)

const AN_ = Nucleus.Coordinate.get_polar(AA; pl = true)

# ---- #

@test AN_ == [
    4.613493863132031,
    4.623988611262445,
    4.289663707024984,
    5.190467066616274,
    3.122061514443475,
    0.32751146228354094,
]

# ---- #

# 188.625 μs (6 allocations: 640 bytes)
#@btime Nucleus.Coordinate.get_polar(AA) setup = seed!(20240423);

# ---- #

const PA = Nucleus.Coordinate.make_unit(AN_)

# ---- #

@test PA[1, :] == AN_

# ---- #

@test PA[2, :] == ones(lastindex(AN_))

# ---- #

# 29.314 ns (1 allocation: 160 bytes)
#@btime Nucleus.Coordinate.make_unit(AN_);

# ---- #

for (xc, yc, re) in ((1, 1, 1 / 3), (-1, 1, 2 / 3), (-1, -1, 4 / 3), (1, -1, 5 / 3))

    yc *= sqrt(3)

    an, ra = Nucleus.Coordinate.convert_cartesian_to_polar(xc, yc)

    @test isapprox(an, pi * re)

    @test isapprox(ra, 2)

    x2, y2 = Nucleus.Coordinate.convert_polar_to_cartesian(an, ra)

    @test isapprox(x2, xc)

    @test isapprox(y2, yc)

    # 10.427 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)
    # 10.427 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)
    # 10.426 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)
    # 10.427 ns (0 allocations: 0 bytes)
    # 7.666 ns (0 allocations: 0 bytes)

    #@btime Nucleus.Coordinate.convert_cartesian_to_polar($xc, $yc)

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

# 128.247 ns (2 allocations: 320 bytes)
#@btime Nucleus.Coordinate.convert_cartesian_to_polar(
#    Nucleus.Coordinate.convert_polar_to_cartesian(PA),
#);

# ---- #

const LAYOUT = Dict("height" => 833, "width" => 833)

# ---- #

Nucleus.Plot.plot(
    joinpath(Nucleus.TE, "polar.html"),
    [
        Dict(
            "type" => "scatterpolar",
            "theta" => PA[1, :] / pi * 180,
            "r" => PA[2, :],
            "text" => axes(PA, 2),
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Nucleus.Color.HEYE),
        ),
    ],
    LAYOUT,
)

# ---- #

const OA = Nucleus.Coordinate.convert_polar_to_cartesian(PA)

# ---- #

Nucleus.Plot.plot(
    joinpath(Nucleus.TE, "cartesian.html"),
    [
        Dict(
            "name" => "Cartesian",
            "x" => CA[1, :],
            "y" => CA[2, :],
            "text" => axes(CA, 2),
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Nucleus.Color.HEGR),
        ),
        Dict(
            "name" => "Polar Cartesian",
            "x" => OA[1, :],
            "y" => OA[2, :],
            "text" => axes(OA, 2),
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Nucleus.Color.HEYE),
        ),
    ],
    LAYOUT,
)
