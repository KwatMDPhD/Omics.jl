using Random: seed!

using Test: @test

using Omics

# ---- #

# 71.500 μs (6 allocations: 560 bytes)

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

    u1 = 1000

    co_ = Vector{Float64}(undef, u1)

    te_ = similar(co_)

    pr_ = similar(co_)

    ac_ = similar(co_, Bool)

    seed!(20240423)

    an_ = Omics.PolarCoordinate.ge!(di; u1, co_, te_, pr_, ac_)

    @test isapprox(an_, re)

    #@btime Omics.PolarCoordinate.ge!($di)

    seed!()

    Omics.PolarCoordinate.plot("", co_, te_, pr_, ac_)

    Omics.Plot.plot(
        "",
        (
            Dict(
                "type" => "scatterpolar",
                "thetaunit" => "radians",
                "theta" => an_,
                "r" => ones(lastindex(an_)),
                "text" => eachindex(an_),
                "mode" => "text",
                "textfont" => Dict("size" => 24),
            ),
        ),
    )

end
