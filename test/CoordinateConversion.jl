using Test: @test

using Omics

# ---- #

# 10.666 ns (0 allocations: 0 bytes)
# 10.135 ns (0 allocations: 0 bytes)
# 10.636 ns (0 allocations: 0 bytes)
# 10.125 ns (0 allocations: 0 bytes)
# 10.636 ns (0 allocations: 0 bytes)
# 8.916 ns (0 allocations: 0 bytes)
# 10.677 ns (0 allocations: 0 bytes)
# 8.884 ns (0 allocations: 0 bytes)

for (x1, y1, re) in ((1, 1, 1 / 3), (-1, 1, 2 / 3), (-1, -1, 4 / 3), (1, -1, 5 / 3))

    y1 *= sqrt(3)

    an, ra = Omics.CoordinateConversion.convert_cartesian_to_polar(x1, y1)

    @test isapprox(an, pi * re)

    @test isapprox(ra, 2)

    @btime Omics.CoordinateConversion.convert_cartesian_to_polar($x1, $y1)

    x2, y2 = Omics.CoordinateConversion.convert_polar_to_cartesian(an, ra)

    @test isapprox(x1, x2)

    @test isapprox(y1, y2)

    @btime Omics.CoordinateConversion.convert_polar_to_cartesian($an, $ra)

end

# ---- #

const DI = [
    0 1 2 3 4 5
    1 0 3 4 5 6
    2 3 0 5 6 7
    3 4 5 0 7 8
    4 5 6 7 0 9
    5 6 7 8 9 0.0
]

const UP = size(DI, 1)

# ---- #

# 20.896 ns (2 allocations: 176 bytes)

const AN_ = Omics.Coordinate.get_polar!(DI)

const PO = Omics.CoordinateConversion.make_unit(AN_)

@test PO[1, :] == AN_

@test PO[2, :] == ones(UP)

@btime Omics.CoordinateConversion.make_unit(AN_);

# ---- #

# 114.028 ns (4 allocations: 352 bytes)

@test isapprox(
    PO,
    Omics.CoordinateConversion.convert_cartesian_to_polar(
        Omics.CoordinateConversion.convert_polar_to_cartesian(PO),
    ),
)

@btime Omics.CoordinateConversion.convert_cartesian_to_polar(
    Omics.CoordinateConversion.convert_polar_to_cartesian(PO),
);

# ---- #

Omics.Plot.plot(
    joinpath(tempdir(), "polar.html"),
    (
        Dict(
            "type" => "scatterpolar",
            "thetaunit" => "radians",
            "theta" => PO[1, :],
            "r" => PO[2, :],
            "text" => 1:UP,
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Omics.Color.YE),
        ),
    ),
)

# ---- #

const C1 = Omics.Coordinate.get_cartesian(DI)

const C2 = Omics.CoordinateConversion.convert_polar_to_cartesian(PO)

Omics.Plot.plot(
    joinpath(tempdir(), "cartesian.html"),
    (
        Dict(
            "name" => "Cartesian",
            "x" => C1[1, :],
            "y" => C1[2, :],
            "text" => 1:UP,
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Omics.Color.GR),
        ),
        Dict(
            "name" => "Polar Cartesian",
            "x" => C2[1, :],
            "y" => C2[2, :],
            "text" => 1:UP,
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Omics.Color.YE),
        ),
    ),
)
