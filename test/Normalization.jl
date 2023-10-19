using Test: @test

using BioLab

# ---- #

const NU___ =
    ([0.0, 1, 2], [-1, 0, 0.3333333333333333, 1], BioLab.Simulation.make_matrix_1n(Float64, 2, 3))

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

    BioLab.Normalization.normalize_with_0!(co)

    @test co == re

    # 25.291 ns (0 allocations: 0 bytes)
    # 26.833 ns (0 allocations: 0 bytes)
    # 29.666 ns (0 allocations: 0 bytes)
    #@btime BioLab.Normalization.normalize_with_0!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(NU___, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1], [0 0.4 0.8; 0.2 0.6 1]))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_01!(co)

    @test co == re

    # 10.625 ns (0 allocations: 0 bytes)
    # 12.291 ns (0 allocations: 0 bytes)
    # 16.625 ns (0 allocations: 0 bytes)
    #@btime BioLab.Normalization.normalize_with_01!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(
    NU___,
    (
        [0, 0.3333333333333333, 0.6666666666666666],
        (),
        [
            0.047619047619047616 0.14285714285714285 0.23809523809523808
            0.09523809523809523 0.19047619047619047 0.2857142857142857
        ],
    ),
)

    if isempty(re)

        continue

    end

    co = copy(nu_)

    BioLab.Normalization.normalize_with_sum!(co)

    @test co == re

    # 7.291 ns (0 allocations: 0 bytes)
    # 10.208 ns (0 allocations: 0 bytes)
    #@btime BioLab.Normalization.normalize_with_sum!(co) setup = (co = copy($nu_)) evals = 1000

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

    BioLab.Normalization.normalize_with_logistic!(co)

    @test co == re

    # 21.708 ns (0 allocations: 0 bytes)
    # 22.000 ns (0 allocations: 0 bytes)
    # 23.916 ns (0 allocations: 0 bytes)
    #@btime BioLab.Normalization.normalize_with_logistic!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

const ARR_ = ([-1, 0, 0, 1, 1, 1, 2], [-1 0 1 2; 0 1 1 3])

# ---- #

for (nu_, re) in zip(ARR_, ([1, 2, 2, 3, 3, 3, 4], [1 2 3 4; 2 3 3 5]))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1223!(co)

    @test co == re

    # 240.791 ns (2 allocations: 224 bytes)
    # 283.750 ns (6 allocations: 432 bytes)
    #@btime BioLab.Normalization.normalize_with_1223!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(ARR_, ([1, 2, 2, 4, 4, 4, 7], [1 2 4 7; 2 4 4 8]))

    co = copy(nu_)

    BioLab.Normalization.normalize_with_1224!(co)

    @test co == re

    # 240.209 ns (2 allocations: 224 bytes)
    # 284.917 ns (6 allocations: 432 bytes)
    #@btime BioLab.Normalization.normalize_with_1224!(co) setup = (co = copy($nu_)) evals = 1000

end

# ---- #

for (nu_, re) in zip(ARR_, ([1, 2.5, 2.5, 5, 5, 5, 7], [1 2.5 5 7; 2.5 5 5 8]))

    co = float.(nu_)

    BioLab.Normalization.normalize_with_125254!(co)

    @test co == re

    # 248.542 ns (2 allocations: 224 bytes)
    # 296.500 ns (6 allocations: 432 bytes)
    #@btime BioLab.Normalization.normalize_with_125254!(co) setup = (co = float.($nu_)) evals = 1000

end

# ---- #

const FU_ = (
    BioLab.Normalization.normalize_with_0!,
    BioLab.Normalization.normalize_with_01!,
    BioLab.Normalization.normalize_with_sum!,
    BioLab.Normalization.normalize_with_logistic!,
    BioLab.Normalization.normalize_with_1223!,
    BioLab.Normalization.normalize_with_1224!,
    BioLab.Normalization.normalize_with_125254!,
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
    ),
)

    co = copy(MA)

    foreach(fu, eachcol(co))

    @test isapprox(co, re; atol = 0.00001)

    # 69.875 ns (0 allocations: 0 bytes)
    # 21.000 ns (0 allocations: 0 bytes)
    # 27.250 ns (0 allocations: 0 bytes)
    # 66.625 ns (0 allocations: 0 bytes)
    # 3.067 μs (24 allocations: 1.31 KiB)
    # 3.069 μs (24 allocations: 1.31 KiB)
    # 3.054 μs (24 allocations: 1.31 KiB)
    #@btime foreach($fu, ea_) setup = (ea_ = eachcol(copy(MA))) evals = 1000

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
    ),
)

    co = copy(MA)

    foreach(fu, eachrow(co))

    @test isapprox(co, re; atol = 0.00001)

    # 71.333 ns (0 allocations: 0 bytes)
    # 27.459 ns (0 allocations: 0 bytes)
    # 29.667 ns (0 allocations: 0 bytes)
    # 71.291 ns (0 allocations: 0 bytes)
    # 3.106 μs (24 allocations: 1.31 KiB)
    # 3.116 μs (24 allocations: 1.31 KiB)
    # 3.418 μs (24 allocations: 1.31 KiB)
    #@btime foreach($fu, ea_) setup = (ea_ = eachrow(copy(MA))) evals = 1000

end
