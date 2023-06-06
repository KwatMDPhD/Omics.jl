include("environment.jl")

# ---- #

nu___ = ([0.0, 1, 2], [-1, 0, 1 / 3, 1])

# ---- #

@test @is_error BioLab.Normalization.normalize_with_01!([1.0, 1])

# ---- #

for (nu_, re) in zip(nu___, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1]))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_01!(co)

    @test co == re

    # 
    # @btime BioLab.Normalization.normalize_with_01!(co) setup = (co = copy($nu_))

end

# ---- #

@test @is_error BioLab.Normalization.normalize_with_0!([1.0, 1])

# ---- #

for (nu_, re) in zip(nu___, ([-1.0, 0, 1], [-1.3, -0.09999999999999999, 0.30000000000000004, 1.1]))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_0!(co)

    @test co == re

    # 
    # @btime BioLab.Normalization.normalize_with_0!(co) setup = (co = copy($nu_))

end

# ---- #

@test @is_error BioLab.Normalization.normalize_with_sum!([-1.0, 1])

# ---- #

for (nu_, re) in zip(nu___[1:(end - 1)], ([0, 0.3333333333333333, 0.6666666666666666],))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_sum!(co)

    @test co == re

    # 
    # @btime BioLab.Normalization.normalize_with_sum!(co) setup = (co = copy($nu_))

end

# ---- #

nu___ = ([-1.0, 0, 0, 1, 1, 1, 2],)

# ---- #

for (nu_, re) in zip(nu___, ([1.0, 2, 3, 4, 5, 6, 7],))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1234!(co)

    @test co == re

    # 
    # @btime BioLab.Normalization.normalize_with_1234!(co) setup = (co = copy($nu_))

end

# ---- #

for (nu_, re) in zip(nu___, ([1.0, 2, 2, 3, 3, 3, 4],))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1223!(co)

    @test co == re

    # 
    # @btime BioLab.Normalization.normalize_with_1223!(co) setup = (co = copy($nu_))

end

# ---- #

for (nu_, re) in zip(nu___, ([1.0, 2, 2, 4, 4, 4, 7],))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1224!(co)

    @test co == re

    # 
    # @btime BioLab.Normalization.normalize_with_1224!(co) setup = (co = copy($nu_))

end

# ---- #

for (nu_, re) in zip(nu___, ([1.0, 2.5, 2.5, 5, 5, 5, 7],))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_125254!(co)

    @test co == re

    # 
    # @btime BioLab.Normalization.normalize_with_125254!(co) setup = (co = copy($nu_))

end

# ---- #

no!_ = (
    BioLab.Normalization.normalize_with_01!,
    BioLab.Normalization.normalize_with_0!,
    BioLab.Normalization.normalize_with_sum!,
    BioLab.Normalization.normalize_with_1234!,
    BioLab.Normalization.normalize_with_1223!,
    BioLab.Normalization.normalize_with_1224!,
    BioLab.Normalization.normalize_with_125254!,
)

# ---- #

for no! in no!_

    @is_error no!([1.0, 1, 1])

end

# ---- #

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

    co = copy(nu_)

    BioLab.VectorNumber.skip_nan_apply!!(no!, co)

    @test isequal(co, re)

    # 
    # @btime BioLab.VectorNumber.skip_nan_apply!!($no!, co) setup = (co = copy($nu_))

end

# ---- #

ro_x_co_x_nu = [
    1.0 10 100 100
    2 20 200 200
    3 30 300 300
    3 30 300 300
]

# ---- #

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

    co = copy(ro_x_co_x_nu)

    foreach(no!, eachcol(co))

    @test isapprox(co, re; atol = 10^-5)

    # 
    # @btime foreach($no!, eachcol(co)) setup = (co = copy(ro_x_co_x_nu))

end

# ---- #

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

    co = copy(ro_x_co_x_nu)

    foreach(no!, eachrow(co))

    @test isapprox(co, re; atol = 10^-5)

    # 
    # @btime foreach($no!, eachrow(co)) setup = (co = copy(ro_x_co_x_nu))

end
