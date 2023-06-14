include("environment.jl")

# ---- #

for ar in ([-1, 1], [-1.0, 1], [-1 1])

    @test @is_error BioLab.NumberArray.error_negative(ar)

end

# ---- #

for (ar, re) in
    (([-1, 0], -0.5), ([0, 1], 0.5), ([-1, 0, 0, 1], 0), ([-1 0; 0 1], 0), ([-1 1; 0 2], 0.5))

    @test BioLab.NumberArray.get_area(ar) == re

end

# ---- #

for (ar, re) in (
    ([0], (0,)),
    ([0, 0], (0,)),
    ([-1, -1], (-1,)),
    ([1, 1], (1,)),
    ([-1, 0, 1], (-1, 1)),
    ([-1, 0, 2], (2,)),
    ([-2, 0, 1], (-2,)),
    ([-2, 0, 2], (-2, 2)),
    ([0 0], (0,)),
    ([-2 0; -1 1], (-2,)),
)

    @test BioLab.NumberArray.get_extreme(ar) == re

end

# ---- #

it_ = collect(-1:9)

for n in 1:3

    @test collect(BioLab.NumberArray.range(it_, n)) == collect(-1:9)

end

# ---- #

fl_ = convert(Vector{Float64}, it_)

for (n, re) in ((1, [-1, 9]), (2, [-1, 4, 9]), (4, [-1, 1.5, 4, 6.5, 9]), (10, fl_))

    @test collect(BioLab.NumberArray.range(fl_, n)) == re

end

# ---- #

ar = [1, NaN, 2, NaN, 3, NaN]

re = [11, NaN, 12, NaN, 13, NaN]

# ---- #

function fu!(ar)

    ar .+= 10

end

co = copy(ar)

BioLab.NumberArray.skip_nan_apply!!(fu!, co)

@test isequal(co, re)

# ---- #

function fu(ar)

    [nu + 10 for nu in ar]

end

co = copy(ar)

BioLab.NumberArray.skip_nan_apply!(fu, co)

@test isequal(co, re)

# ---- #

ar = collect(-2:3)

si = (2, 3)

for (mi, re) in zip(
    vcat(ar, "0<", "1.2<"),
    (
        [-2, -1, 0, 1, 2, 3],
        [-1, 0, 1, 2, 3, 4],
        [0, 1, 2, 3, 4, 5],
        [1, 2, 3, 4, 5, 6],
        [2, 3, 4, 5, 6, 7],
        [3, 4, 5, 6, 7, 8],
        [1, 2, 3, 4, 5, 6],
        [2, 3, 4, 5, 6, 7],
    ),
)

    @test BioLab.NumberArray.shift_minimum(ar, mi) == re

    @test BioLab.NumberArray.shift_minimum(reshape(ar, si), mi) == reshape(re, si)

end

# ---- #

ar2_ = ([1.0, 1], [1.0 1])

ar_ = ([0.0, 1, 2], [-1, 0, 1 / 3, 1], Matrix(reshape(1.0:6, (2, 3))))

# ---- #

for ar in ar2_

    @test @is_error BioLab.NumberArray.normalize_with_01!(ar)

end

# ---- #

for (ar, re) in
    zip(ar_, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1], [0.0 0.4 0.8; 0.2 0.6 1.0]))

    co = copy(ar)

    BioLab.NumberArray.normalize_with_01!(co)

    @test co == re

end

# ---- #

for ar in ar2_

    @test @is_error BioLab.NumberArray.normalize_with_0!(ar)

end

# ---- #

for (ar, re) in zip(
    ar_,
    (
        [-1, 0, 1],
        [-1.3, -0.09999999999999999, 0.30000000000000004, 1.1],
        [
            -1.3363062095621219 -0.2672612419124244 0.8017837257372732
            -0.8017837257372732 0.2672612419124244 1.3363062095621219
        ],
    ),
)

    co = copy(ar)

    BioLab.NumberArray.normalize_with_0!(co)

    @test co == re

end

# ---- #

@test @is_error BioLab.NumberArray.normalize_with_sum!(ar_[2])

# ---- #

for (ar, re) in zip(
    ar_[[1, 3]],
    (
        [0, 0.3333333333333333, 0.6666666666666666],
        [
            0.047619047619047616 0.14285714285714285 0.23809523809523808
            0.09523809523809523 0.19047619047619047 0.2857142857142857
        ],
    ),
)

    co = copy(ar)

    BioLab.NumberArray.normalize_with_sum!(co)

    @test co == re

end

# ---- #

ar_ = ([-1, 0, 0, 1, 1, 1, 2], [-1 0 1 2; 0 1 1 3])

# ---- #

for ar in ar2_

    @test @is_error BioLab.NumberArray.normalize_with_1234!(-ar)

end

# ---- #

for (ar, re) in zip(ar_, ([1, 2, 3, 4, 5, 6, 7], [1 3 5 7; 2 4 6 8]))

    co = copy(ar)

    BioLab.NumberArray.normalize_with_1234!(co)

    @test co == re

end

# ---- #

for ar in ar2_

    @test @is_error BioLab.NumberArray.normalize_with_1223!(-ar)

end

# ---- #

for (ar, re) in zip(ar_, ([1, 2, 2, 3, 3, 3, 4], [1 2 3 4; 2 3 3 5]))

    co = copy(ar)

    BioLab.NumberArray.normalize_with_1223!(co)

    @test co == re

end

# ---- #

for ar in ar2_

    @test @is_error BioLab.NumberArray.normalize_with_1224!(-ar)

end

# ---- #

for (ar, re) in zip(ar_, ([1, 2, 2, 4, 4, 4, 7], [1 2 4 7; 2 4 4 8]))

    co = copy(ar)

    BioLab.NumberArray.normalize_with_1224!(co)

    @test co == re

end

# ---- #

for ar in ar2_

    @test @is_error BioLab.NumberArray.normalize_with_125254!(-ar)

end

# ---- #

for (ar, re) in zip(ar_, ([1, 2.5, 2.5, 5, 5, 5, 7], [1 2.5 5 7; 2.5 5 5 8]))

    co = float.(ar)

    BioLab.NumberArray.normalize_with_125254!(co)

    @test co == re

end

# ---- #

no!_ = (
    BioLab.NumberArray.normalize_with_01!,
    BioLab.NumberArray.normalize_with_0!,
    BioLab.NumberArray.normalize_with_sum!,
    BioLab.NumberArray.normalize_with_1234!,
    BioLab.NumberArray.normalize_with_1223!,
    BioLab.NumberArray.normalize_with_1224!,
    BioLab.NumberArray.normalize_with_125254!,
)

# ---- #

ar = [NaN, 1, 2, 2, 3, NaN]

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

    co = copy(ar)

    BioLab.NumberArray.skip_nan_apply!!(no!, co)

    @test isequal(co, re)

end

# ---- #

ma = [
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
            0 0 0 0
            0.5 0.5 0.5 0.5
            1 1 1 1
            1 1 1 1
        ],
        [
            -1.30558 -1.30558 -1.30558 -1.30558
            -0.261116 -0.261116 -0.261116 -0.261116
             0.783349 0.783349 0.783349 0.783349
             0.783349 0.783349 0.783349 0.783349
        ],
        [
            0.111111 0.111111 0.111111 0.111111
            0.222222 0.222222 0.222222 0.222222
            0.333333 0.333333 0.333333 0.333333
            0.333333 0.333333 0.333333 0.333333
        ],
        [
            1 1 1 1
            2 2 2 2
            3 3 3 3
            4 4 4 4
        ],
        [
            1 1 1 1
            2 2 2 2
            3 3 3 3
            3 3 3 3
        ],
        [
            1 1 1 1
            2 2 2 2
            3 3 3 3
            3 3 3 3
        ],
        [
            1 1 1 1
            2 2 2 2
            3.5 3.5 3.5 3.5
            3.5 3.5 3.5 3.5
        ],
    ),
)

    co = copy(ma)

    foreach(no!, eachcol(co))

    @test isapprox(co, re; atol = 10^-5)

end

# ---- #

for (no!, re) in zip(
    no!_,
    (
        [
            0 0.0909091 1 1
            0 0.0909091 1 1
            0 0.0909091 1 1
            0 0.0909091 1 1
        ],
        [
            -0.94636 -0.781776 0.864068 0.864068
            -0.94636 -0.781776 0.864068 0.864068
            -0.94636 -0.781776 0.864068 0.864068
            -0.94636 -0.781776 0.864068 0.864068
        ],
        [
            0.00473934 0.0473934 0.473934 0.473934
            0.00473934 0.0473934 0.473934 0.473934
            0.00473934 0.0473934 0.473934 0.473934
            0.00473934 0.0473934 0.473934 0.473934
        ],
        [
            1 2 3 4
            1 2 3 4
            1 2 3 4
            1 2 3 4
        ],
        [
            1 2 3 3
            1 2 3 3
            1 2 3 3
            1 2 3 3
        ],
        [
            1 2 3 3
            1 2 3 3
            1 2 3 3
            1 2 3 3
        ],
        [
            1 2 3.5 3.5
            1 2 3.5 3.5
            1 2 3.5 3.5
            1 2 3.5 3.5
        ],
    ),
)

    co = copy(ma)

    foreach(no!, eachrow(co))

    @test isapprox(co, re; atol = 10^-5)

end
