using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

nn = [
    0 1 2 3 4 5
    1 0 3 4 5 6
    2 3 0 5 6 7
    3 4 5 0 7 8
    4 5 6 7 0 9
    5 6 7 8 9 0.0
]

# ---- #

seed!(20240423)

an_, ob_, te_, ac_ = Nucleus.Radar.anneal(nn)

Nucleus.Radar.plot_annealing(joinpath(Nucleus.TE, "annealing.html"), ob_, te_, ac_)

seed!(20240423)

# 78.542 μs (10 allocations: 17.09 KiB)
#@btime Nucleus.Radar.anneal(nn);

# ---- #

pn = Matrix{Float64}(undef, 2, lastindex(an_))

pn[1, :] = an_

pn[2, :] .= 1

# ---- #

for (xc, yc, re) in ((1, 1, 1 / 3), (-1, 1, 2 / 3), (-1, -1, 4 / 3), (1, -1, 5 / 3))

    yc = yc * sqrt(3)

    an, ra = Nucleus.Radar.convert_cartesian_to_polar(xc, yc)

    @test isapprox(an, pi * re)

    @test isapprox(ra, 2)

    x2, y2 = Nucleus.Radar.convert_polar_to_cartesian(an, ra)

    @test isapprox(x2, xc)

    @test isapprox(y2, yc)

    # 10.468 ns (0 allocations: 0 bytes)
    # 7.675 ns (0 allocations: 0 bytes)
    # 10.468 ns (0 allocations: 0 bytes)
    # 7.674 ns (0 allocations: 0 bytes)
    # 10.468 ns (0 allocations: 0 bytes)
    # 7.674 ns (0 allocations: 0 bytes)
    # 10.468 ns (0 allocations: 0 bytes)
    # 7.716 ns (0 allocations: 0 bytes)

    #@btime Nucleus.Radar.convert_cartesian_to_polar($xc, $yc)

    #@btime Nucleus.Radar.convert_polar_to_cartesian($an, $ra)

end

@test isapprox(
    pn,
    Nucleus.Radar.convert_cartesian_to_polar(Nucleus.Radar.convert_polar_to_cartesian(pn)),
)

# 123.754 ns (2 allocations: 320 bytes)
#@btime Nucleus.Radar.convert_cartesian_to_polar(Nucleus.Radar.convert_polar_to_cartesian(pn));

# ---- #

np = [
    0.8 0 0 0 0 0 0.1
    0 0.8 0 0 0 0 0.1
    0 0 0.8 0 0 0 0.1
    0 0 0 0.8 0 0 0.1
    0 0 0 0 0.8 0 0.1
    0 0 0 0 0 0.8 0.1
]

# ---- #

cn = Nucleus.Radar.convert_polar_to_cartesian(pn)

cp = cn * np

pp = Nucleus.Radar.convert_cartesian_to_polar(cp)

# ---- #

no_ = ["Node $id" for id in axes(pn, 2)]

po_ = ["Point $id" for id in axes(pp, 2)]

# ---- #

Nucleus.Plot.plot(
    joinpath(Nucleus.TE, "cartesian.html"),
    [
        Dict(
            "name" => "Node",
            "y" => cn[1, :],
            "x" => cn[2, :],
            "text" => no_,
            "mode" => "markers+text",
            "marker" => Dict("size" => 48, "color" => "#ffff00"),
        ),
        Dict(
            "name" => "Point",
            "y" => cp[1, :],
            "x" => cp[2, :],
            "text" => po_,
            "mode" => "markers+text",
            "marker" => Dict("size" => 24, "color" => "#00ffff"),
        ),
    ],
    Dict("height" => 800, "width" => 800),
)

# ---- #

Nucleus.Plot.plot(
    joinpath(Nucleus.TE, "polar.html"),
    [
        Dict(
            "type" => "scatterpolar",
            "name" => "Node",
            "theta" => pn[1, :] / pi * 180,
            "r" => pn[2, :],
            "text" => no_,
            "mode" => "markers+text",
            "marker" => Dict("size" => 48, "color" => "#ffff00"),
        ),
        Dict(
            "type" => "scatterpolar",
            "name" => "Point",
            "theta" => pp[1, :] / pi * 180,
            "r" => pp[2, :],
            "text" => po_,
            "mode" => "markers+text",
            "marker" => Dict("size" => 24, "color" => "#00ffff"),
        ),
    ],
    Dict(
        "polar" => Dict(
            "angularaxis" =>
                Dict("showgrid" => false, "ticks" => "", "showticklabels" => false),
            "radialaxis" => Dict(
                "showline" => false,
                "showgrid" => false,
                "ticks" => "",
                "showticklabels" => false,
            ),
        ),
    ),
)
