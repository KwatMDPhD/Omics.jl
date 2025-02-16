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
    (
        [
            0 1 2 3 4 5
            1 0 3 4 5 6
            2 3 0 5 6 7
            3 4 5 0 7 8
            4 5 6 7 0 9
            5 6 7 8 9 0.0
        ],
        [
            -0.330892 0.234306 -2.37577 -0.579723 -2.36946 5.42154
            0.206667 -0.048689 0.658987 3.79547 -4.04981 -0.562631
        ],
    ),
)

    seed!(20231210)

    xy = Omics.CartesianCoordinate.ge(di)

    @test isapprox(xy, re; atol = 1e-5)

    seed!()

    Omics.Plot.plot(
        "",
        (
            Dict(
                "y" => xy[2, :],
                "x" => xy[1, :],
                "text" => axes(xy, 2),
                "mode" => "text",
                "textfont" => Dict("size" => 24),
            ),
        ),
        Dict("height" => 800, "width" => 800),
    )

end
