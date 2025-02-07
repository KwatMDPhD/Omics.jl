using Random: seed!

using Test: @test

using Omics

# ---- #

const PA = Omics.Coordinate.make_unit(AN_)

# ---- #

@test PA[1, :] == AN_

# ---- #

@test PA[2, :] == ones(lastindex(AN_))

# 29.314 ns (1 allocation: 160 bytes)
#@btime Omics.Coordinate.make_unit(AN_);

# ---- #

for (xc, yc, re) in ((1, 1, 1 / 3), (-1, 1, 2 / 3), (-1, -1, 4 / 3), (1, -1, 5 / 3))

    yc *= sqrt(3)

    an, ra = Omics.Coordinate.convert_cartesian_to_polar(xc, yc)

    @test isapprox(an, pi * re)

    @test isapprox(ra, 2)

    x2, y2 = Omics.Coordinate.convert_polar_to_cartesian(an, ra)

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

    #@btime Omics.Coordinate.convert_cartesian_to_polar($xc, $yc)

    #@btime Omics.Coordinate.convert_polar_to_cartesian($an, $ra)

end

# ---- #

@test isapprox(
    PA,
    Omics.Coordinate.convert_cartesian_to_polar(
        Omics.Coordinate.convert_polar_to_cartesian(PA),
    ),
)

# ---- #

# 128.247 ns (2 allocations: 320 bytes)
#@btime Omics.Coordinate.convert_cartesian_to_polar(
#    Omics.Coordinate.convert_polar_to_cartesian(PA),
#);

# ---- #

const LA = Dict("height" => 833, "width" => 833)

Omics.Plot.plot(
    joinpath(tempdir(), "polar.html"),
    [
        Dict(
            "type" => "scatterpolar",
            "theta" => PA[1, :] / pi * 180,
            "r" => PA[2, :],
            "text" => axes(PA, 2),
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Omics.Color.YE),
        ),
    ],
    LA,
)

# ---- #

const OA = Omics.Coordinate.convert_polar_to_cartesian(PA)

Omics.Plot.plot(
    joinpath(tempdir(), "cartesian.html"),
    [
        Dict(
            "name" => "Cartesian",
            "x" => CA[1, :],
            "y" => CA[2, :],
            "text" => axes(CA, 2),
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Omics.Color.GR),
        ),
        Dict(
            "name" => "Polar Cartesian",
            "x" => OA[1, :],
            "y" => OA[2, :],
            "text" => axes(OA, 2),
            "mode" => "markers+text",
            "marker" => Dict("size" => 40, "color" => Omics.Color.YE),
        ),
    ],
    LA,
)
