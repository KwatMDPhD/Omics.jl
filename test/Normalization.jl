using Test: @test

using Nucleus

# ---- #

const NU___ =
    ([0.0, 1, 2], [-1, 0, 0.3333333333333333, 1], Nucleus.Simulation.make_matrix_1n(Float64, 2, 3))

# ---- #

for (nu_, re) in zip(
    NU___,
    (
        [-1, 0, 1],
        [-1.3, -0.09999999999999999, 0.30000000000000004, 1.1],
        [
            -1.3363062095621219 -0.2672612419124244 0.8017837257372732
            -0.8017837257372732 0.2672612419124244 1.3363062095621219
        ],
    ),
)

    co = copy(nu_)

    Nucleus.Normalization.normalize_with_0!(co)

    @test co == re

    # 25.291 ns (0 allocations: 0 bytes)
    # 26.792 ns (0 allocations: 0 bytes)
    # 29.666 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Normalization.normalize_with_0!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(NU___, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1], [0 0.4 0.8; 0.2 0.6 1]))

    co = copy(nu_)

    Nucleus.Normalization.normalize_with_01!(co)

    @test co == re

    # 10.625 ns (0 allocations: 0 bytes)
    # 12.291 ns (0 allocations: 0 bytes)
    # 16.625 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Normalization.normalize_with_01!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(
    NU___,
    (
        [0, 0.3333333333333333, 0.6666666666666666],
        nothing,
        [
            0.047619047619047616 0.14285714285714285 0.23809523809523808
            0.09523809523809523 0.19047619047619047 0.2857142857142857
        ],
    ),
)

    if isnothing(re)

        continue

    end

    co = copy(nu_)

    Nucleus.Normalization.normalize_with_sum!(co)

    @test co == re

    # 7.291 ns (0 allocations: 0 bytes)
    # 10.125 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Normalization.normalize_with_sum!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(
    NU___,
    (
        [0.5, 0.7310585786300049, 0.8807970779778824],
        [0.2689414213699951, 0.5, 0.5825702064623146, 0.7310585786300049],
        [
            0.7310585786300049 0.9525741268224333 0.9933071490757152
            0.8807970779778824 0.9820137900379085 0.9975273768433652
        ],
    ),
)

    co = copy(nu_)

    Nucleus.Normalization.normalize_with_logistic!(co)

    @test co == re

    # 21.708 ns (0 allocations: 0 bytes)
    # 22.000 ns (0 allocations: 0 bytes)
    # 23.916 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Normalization.normalize_with_logistic!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

const ARR_ = ([-1, 0, 0, 1, 1, 1, 2], [-1 0 1 2; 0 1 1 3])

# ---- #

for (nu_, re) in zip(ARR_, ([1, 2, 2, 3, 3, 3, 4], [1 2 3 4; 2 3 3 5]))

    co = copy(nu_)

    Nucleus.Normalization.normalize_with_1223!(co)

    @test co == re

    # 240.208 ns (2 allocations: 224 bytes)
    # 283.750 ns (6 allocations: 432 bytes)
    #@btime Nucleus.Normalization.normalize_with_1223!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(ARR_, ([1, 2, 2, 4, 4, 4, 7], [1 2 4 7; 2 4 4 8]))

    co = copy(nu_)

    Nucleus.Normalization.normalize_with_1224!(co)

    @test co == re

    # 240.209 ns (2 allocations: 224 bytes)
    # 283.958 ns (6 allocations: 432 bytes)
    #@btime Nucleus.Normalization.normalize_with_1224!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(ARR_, ([1, 2.5, 2.5, 5, 5, 5, 7], [1 2.5 5 7; 2.5 5 5 8]))

    co = float.(nu_)

    Nucleus.Normalization.normalize_with_125254!(co)

    @test co == re

    # 248.416 ns (2 allocations: 224 bytes)
    # 296.500 ns (6 allocations: 432 bytes)
    #@btime Nucleus.Normalization.normalize_with_125254!(co) setup = (co = float.($nu_)) evals = 1000

end

# ---- #

const RE_ = [
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    ones(10),
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    ones(10),
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    ones(Int, 10),
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    ones(Int, 10),
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
]

# ---- #

for nu_ in (
    zeros(10),
    fill(0.1, 10),
    ones(10),
    collect(0.1:0.1:1),
    collect(1:10),
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 100],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 1000],
)

    for qu_ in ((0, 1), (0, 0.5, 1), (0, 1 / 3, 2 / 3, 1), (0, 0.2, 0.4, 0.6, 0.8, 1))

        co = copy(nu_)

        Nucleus.Normalization.normalize_with_quantile!(co, qu_)

        @test co == popfirst!(RE_)

        # 68.375 ns (1 allocation: 144 bytes)
        # 68.375 ns (1 allocation: 144 bytes)
        # 68.333 ns (1 allocation: 144 bytes)
        # 68.375 ns (1 allocation: 144 bytes)
        # 68.333 ns (1 allocation: 144 bytes)
        # 68.500 ns (1 allocation: 144 bytes)
        # 68.417 ns (1 allocation: 144 bytes)
        # 68.375 ns (1 allocation: 144 bytes)
        # 68.375 ns (1 allocation: 144 bytes)
        # 68.375 ns (1 allocation: 144 bytes)
        # 68.916 ns (1 allocation: 144 bytes)
        # 68.375 ns (1 allocation: 144 bytes)
        # 69.833 ns (1 allocation: 144 bytes)
        # 69.833 ns (1 allocation: 144 bytes)
        # 69.792 ns (1 allocation: 144 bytes)
        # 69.833 ns (1 allocation: 144 bytes)
        # 473.458 ns (46 allocations: 1.31 KiB)
        # 473.250 ns (46 allocations: 1.31 KiB)
        # 473.417 ns (46 allocations: 1.31 KiB)
        # 473.375 ns (46 allocations: 1.31 KiB)
        # 473.292 ns (46 allocations: 1.31 KiB)
        # 474.000 ns (46 allocations: 1.31 KiB)
        # 473.375 ns (46 allocations: 1.31 KiB)
        # 473.416 ns (46 allocations: 1.31 KiB)
        # 473.500 ns (46 allocations: 1.31 KiB)
        # 473.584 ns (46 allocations: 1.31 KiB)
        # 473.750 ns (46 allocations: 1.31 KiB)
        # 473.625 ns (46 allocations: 1.31 KiB)
        #@btime Nucleus.Normalization.normalize_with_quantile!(co) setup = (co = copy($nu_)) evals = 1000

    end

end

# ---- #

const FU_ = (
    Nucleus.Normalization.normalize_with_0!,
    Nucleus.Normalization.normalize_with_01!,
    Nucleus.Normalization.normalize_with_sum!,
    Nucleus.Normalization.normalize_with_logistic!,
    Nucleus.Normalization.normalize_with_1223!,
    Nucleus.Normalization.normalize_with_1224!,
    Nucleus.Normalization.normalize_with_125254!,
    Nucleus.Normalization.normalize_with_quantile!,
)

# ---- #

const MA = [
    1.0 10 100 100
    2 20 200 200
    3 30 300 300
    3 30 300 300
]

# ---- #

for (fu, re) in zip(
    FU_,
    (
        [
            -1.30558 -1.30558 -1.30558 -1.30558
            -0.261116 -0.261116 -0.261116 -0.261116
             0.783349 0.783349 0.783349 0.783349
             0.783349 0.783349 0.783349 0.783349
        ],
        [
            0 0 0 0
            0.5 0.5 0.5 0.5
            1 1 1 1
            1 1 1 1
        ],
        [
            0.111111 0.111111 0.111111 0.111111
            0.222222 0.222222 0.222222 0.222222
            0.333333 0.333333 0.333333 0.333333
            0.333333 0.333333 0.333333 0.333333
        ],
        [
            0.7310585786300049 0.9999546021312976 1 1
            0.8807970779778824 0.9999999979388464 1 1
            0.9525741268224333 0.9999999999999064 1 1
            0.9525741268224333 0.9999999999999064 1 1
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
        [
            1.0 1 1 1
            1 1 1 1
            2 2 2 2
            2 2 2 2
        ],
    ),
)

    co = copy(MA)

    foreach(fu, eachcol(co))

    @test isapprox(co, re; atol = 0.00001)

    # 70.250 ns (0 allocations: 0 bytes)
    # 21.000 ns (0 allocations: 0 bytes)
    # 28.000 ns (0 allocations: 0 bytes)
    # 68.208 ns (0 allocations: 0 bytes)
    # 3.185 μs (24 allocations: 1.31 KiB)
    # 3.204 μs (24 allocations: 1.31 KiB)
    # 3.132 μs (24 allocations: 1.31 KiB)
    # 256.000 ns (4 allocations: 384 bytes)
    #@btime foreach($fu, ea_) setup = (ea_ = eachcol($co)) evals = 1000

end

# ---- #

for (fu, re) in zip(
    FU_,
    (
        [
            -0.94636 -0.781776 0.864068 0.864068
            -0.94636 -0.781776 0.864068 0.864068
            -0.94636 -0.781776 0.864068 0.864068
            -0.94636 -0.781776 0.864068 0.864068
        ],
        [
            0 0.0909091 1 1
            0 0.0909091 1 1
            0 0.0909091 1 1
            0 0.0909091 1 1
        ],
        [
            0.00473934 0.0473934 0.473934 0.473934
            0.00473934 0.0473934 0.473934 0.473934
            0.00473934 0.0473934 0.473934 0.473934
            0.00473934 0.0473934 0.473934 0.473934
        ],
        [
            0.7310585786300049 0.9999546021312976 1 1
            0.8807970779778824 0.9999999979388464 1 1
            0.9525741268224333 0.9999999999999064 1 1
            0.9525741268224333 0.9999999999999064 1 1
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
        [
            1.0 1 2 2
            1 1 2 2
            1 1 2 2
            1 1 2 2
        ],
    ),
)

    co = copy(MA)

    foreach(fu, eachrow(co))

    @test isapprox(co, re; atol = 0.00001)

    # 88.791 ns (0 allocations: 0 bytes)
    # 27.500 ns (0 allocations: 0 bytes)
    # 30.333 ns (0 allocations: 0 bytes)
    # 149.541 ns (0 allocations: 0 bytes)
    # 3.457 μs (24 allocations: 1.31 KiB)
    # 3.452 μs (24 allocations: 1.31 KiB)
    # 3.550 μs (24 allocations: 1.31 KiB)
    # 340.875 ns (4 allocations: 384 bytes)
    #@btime foreach($fu, ea_) setup = (ea_ = eachrow($co)) evals = 1000

end
