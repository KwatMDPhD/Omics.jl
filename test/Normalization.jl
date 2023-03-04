include("_.jl")

nu__ = ([0.0, 1, 2], [-1, 0, 1 / 3, 1])

@test @is_error BioLab.Normalization.normalize_with_01!([])

@test @is_error BioLab.Normalization.normalize_with_01!([1.0, 1])

for (nu_, re) in zip(nu__, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1]))

    BioLab.print_header(nu_)

    co = copy(nu_)

    BioLab.Normalization.normalize_with_01!(co)

    @test co == re

    # @code_warntype BioLab.Normalization.normalize_with_01!(co)

    # 17.576 ns (0 allocations: 0 bytes)
    # 21.584 ns (0 allocations: 0 bytes)
    # @btime BioLab.Normalization.normalize_with_01!($co) setup = (co = copy($nu_))

end

@test @is_error BioLab.Normalization.normalize_with_0!([])

@test @is_error BioLab.Normalization.normalize_with_0!([1.0, 1])

for (nu_, re) in zip(nu__, ([-1.0, 0, 1], [-1.3, -0.09999999999999999, 0.30000000000000004, 1.1]))

    BioLab.print_header(nu_)

    co = copy(nu_)

    BioLab.Normalization.normalize_with_0!(co)

    @test co == re

    # @code_warntype BioLab.Normalization.normalize_with_0!(co)

    # 25.577 ns (0 allocations: 0 bytes)
    # 26.440 ns (0 allocations: 0 bytes)
    # @btime BioLab.Normalization.normalize_with_0!($co) setup = (co = copy($nu_))

end

@test @is_error BioLab.Normalization.normalize_with_sum!([])

@test @is_error BioLab.Normalization.normalize_with_sum!([-1.0, 1])

for (nu_, re) in zip(nu__, ([0, 0.3333333333333333, 0.6666666666666666], []))

    BioLab.print_header(nu_)

    if any(nu < 0 for nu in nu_)

        continue

    end

    co = copy(nu_)

    BioLab.Normalization.normalize_with_sum!(co)

    @test co == re

    # @code_warntype BioLab.Normalization.normalize_with_sum!(co)

    # 7.041 ns (0 allocations: 0 bytes)
    # @btime BioLab.Normalization.normalize_with_sum!($co) setup = (co = copy($nu_))

end

nu__ = ([0.0], [-1.0, 0, 0, 1, 1, 1, 2])

for (nu_, re) in zip(nu__, ([1.0], [1.0, 2, 3, 4, 5, 6, 7]))

    BioLab.print_header(nu_)

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1234!(co)

    @test co == re

    # @code_warntype BioLab.Normalization.normalize_with_1234!(co)

    # 423.156 ns (3 allocations: 144 bytes)
    # 446.701 ns (3 allocations: 240 bytes)
    # @btime BioLab.Normalization.normalize_with_1234!($co) setup = (co = copy($nu_))

end

for (nu_, re) in zip(nu__, ([1.0], [1.0, 2, 2, 3, 3, 3, 4]))

    BioLab.print_header(nu_)

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1223!(co)

    @test co == re

    # @code_warntype BioLab.Normalization.normalize_with_1223!(co)

    # 420.226 ns (3 allocations: 144 bytes)
    # 449.239 ns (3 allocations: 240 bytes)
    # @btime BioLab.Normalization.normalize_with_1223!($co) setup = (co = copy($nu_))

end

for (nu_, re) in zip(nu__, ([1.0], [1.0, 2, 2, 4, 4, 4, 7]))

    BioLab.print_header(nu_)

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1224!(co)

    @test co == re

    # @code_warntype BioLab.Normalization.normalize_with_1224!(co)

    # 424.412 ns (3 allocations: 144 bytes)
    # 447.543 ns (3 allocations: 240 bytes)
    # @btime BioLab.Normalization.normalize_with_1224!($co) setup = (co = copy($nu_))

end

for (nu_, re) in zip(nu__, ([1.0], [1.0, 2.5, 2.5, 5, 5, 5, 7]))

    BioLab.print_header(nu_)

    co = copy(nu_)

    BioLab.Normalization.normalize_with_125254!(co)

    @test co == re

    # @code_warntype BioLab.Normalization.normalize_with_125254!(co)

    # 421.688 ns (3 allocations: 144 bytes)
    # 448.817 ns (3 allocations: 240 bytes)
    # @btime BioLab.Normalization.normalize_with_125254!($co) setup = (co = copy($nu_))

end

no!_ = (
    BioLab.Normalization.normalize_with_01!,
    BioLab.Normalization.normalize_with_0!,
    BioLab.Normalization.normalize_with_sum!,
    BioLab.Normalization.normalize_with_1234!,
    BioLab.Normalization.normalize_with_1223!,
    BioLab.Normalization.normalize_with_1224!,
    BioLab.Normalization.normalize_with_125254!,
)

nu_ = [NaN, 1, 2, 2, 3, NaN]

for (no!, re) in zip(
    no!_,
    (
        [NaN, 0, 0.5, 0.5, 1, NaN],
        [NaN, -1.224744871391589, 0, 0, 1.224744871391589, NaN],
        [NaN, 0.125, 0.25, 0.25, 0.375, NaN],
        [NaN, 1, 2, 3, 4, NaN],
        [NaN, 1, 2, 2, 3, NaN],
        [NaN, 1, 2, 2, 4, NaN],
        [NaN, 1, 2.5, 2.5, 4, NaN],
    ),
)

    BioLab.print_header("🔫 $no!")

    co = copy(nu_)

    BioLab.VectorNumber.skip_nan_and_apply!!(no!, co)

    @test isequal(co, re)

    # @code_warntype BioLab.VectorNumber.skip_nan_and_apply!!(no!, co)

    # 104.723 ns (2 allocations: 160 bytes)
    # 110.019 ns (2 allocations: 160 bytes)
    # 106.372 ns (2 allocations: 160 bytes)
    # 596.910 ns (8 allocations: 544 bytes)
    # 612.717 ns (8 allocations: 544 bytes)
    # 603.107 ns (8 allocations: 544 bytes)
    # 585.650 ns (8 allocations: 544 bytes)
    # @btime BioLab.VectorNumber.skip_nan_and_apply!!($no!, $co) setup = (co = copy($nu_))

end

ro_x_co_x_nu = [
    1.0 10 100 100
    2 20 200 200
    3 30 300 300
    3 30 300 300
]

BioLab.print_header("🧭 By Column")

for (no!, re) in zip(
    no!_,
    (
        [
            0  0  0  0
            0.5  0.5  0.5  0.5
            1  1  1  1
            1  1  1  1
        ],
        [
            -1.30558   -1.30558   -1.30558   -1.30558
            -0.261116  -0.261116  -0.261116  -0.261116
             0.783349   0.783349   0.783349   0.783349
             0.783349   0.783349   0.783349   0.783349
        ],
        [
            0.111111  0.111111  0.111111  0.111111
            0.222222  0.222222  0.222222  0.222222
            0.333333  0.333333  0.333333  0.333333
            0.333333  0.333333  0.333333  0.333333
        ],
        [
            1.0  1  1  1
            2  2  2  2
            3  3  3  3
            4  4  4  4
        ],
        [
            1.0  1  1  1
            2  2  2  2
            3  3  3  3
            3  3  3  3
        ],
        [
            1.0  1  1  1
            2  2  2  2
            3  3  3  3
            3  3  3  3
        ],
        [
            1  1  1  1
            2  2  2  2
            3.5  3.5  3.5  3.5
            3.5  3.5  3.5  3.5
        ],
    ),
)

    BioLab.print_header("🔫 $no!")

    co = copy(ro_x_co_x_nu)

    BioLab.Matrix.apply_by_column!(no!, co)

    @test isapprox(co, re; atol = 10^-5)

    # @code_warntype BioLab.Matrix.apply_by_column!(no!, co)

    # 96.944 ns (0 allocations: 0 bytes)
    # 114.902 ns (0 allocations: 0 bytes)
    # 69.203 ns (0 allocations: 0 bytes)
    # 968.176 ns (16 allocations: 1.12 KiB)
    # 970.588 ns (16 allocations: 1.12 KiB)
    # 976.214 ns (16 allocations: 1.12 KiB)
    # 970.588 ns (16 allocations: 1.12 KiB)
    # @btime BioLab.Matrix.apply_by_column!($no!, $co) setup = (co = copy(ro_x_co_x_nu))

end

BioLab.print_header("🧭 By Row")

for (no!, re) in zip(
    no!_,
    (
        [
            0  0.0909091  1  1
            0  0.0909091  1  1
            0  0.0909091  1  1
            0  0.0909091  1  1
        ],
        [
            -0.94636  -0.781776  0.864068  0.864068
            -0.94636  -0.781776  0.864068  0.864068
            -0.94636  -0.781776  0.864068  0.864068
            -0.94636  -0.781776  0.864068  0.864068
        ],
        [
            0.00473934  0.0473934  0.473934  0.473934
            0.00473934  0.0473934  0.473934  0.473934
            0.00473934  0.0473934  0.473934  0.473934
            0.00473934  0.0473934  0.473934  0.473934
        ],
        [
            1.0  2  3  4
            1  2  3  4
            1  2  3  4
            1  2  3  4
        ],
        [
            1.0  2  3  3
            1  2  3  3
            1  2  3  3
            1  2  3  3
        ],
        [
            1.0  2  3  3
            1  2  3  3
            1  2  3  3
            1  2  3  3
        ],
        [
            1  2  3.5  3.5
            1  2  3.5  3.5
            1  2  3.5  3.5
            1  2  3.5  3.5
        ],
    ),
)

    BioLab.print_header("🔫 $no!")

    co = copy(ro_x_co_x_nu)

    BioLab.Matrix.apply_by_row!(no!, co)

    @test isapprox(co, re; atol = 10^-5)

    # @code_warntype BioLab.Matrix.apply_by_row!(no!, co)

    # 93.181 ns (0 allocations: 0 bytes)
    # 113.464 ns (0 allocations: 0 bytes)
    # 64.796 ns (0 allocations: 0 bytes)
    # 980.533 ns (16 allocations: 1.12 KiB)
    # 973.938 ns (16 allocations: 1.12 KiB)
    # 962.737 ns (16 allocations: 1.12 KiB)
    # 1.021 μs (16 allocations: 1.12 KiB)
    # @btime BioLab.Matrix.apply_by_row!($no!, $co) setup = (co = copy(ro_x_co_x_nu))

end
