using Test: @test

using BioLab

# ---- #

const NU_ = ([0.0, 1, 2], [-1, 0, 0.3333333333333333, 1], BioLab.Simulation.make_matrix_1n(2, 3))

# ---- #

for (nu, re) in zip(
    NU_,
    (
        [-1, 0, 1],
        [-1.3, -0.09999999999999999, 0.30000000000000004, 1.1],
        [
            -1.3363062095621219 -0.2672612419124244 0.8017837257372732
            -0.8017837257372732 0.2672612419124244 1.3363062095621219
        ],
    ),
)

    co = copy(nu)

    BioLab.Normalization.normalize_with_0!(co)

    @test co == re

    # 25.216 ns (0 allocations: 0 bytes)
    # 26.788 ns (0 allocations: 0 bytes)
    # 29.648 ns (0 allocations: 0 bytes)
    @btime BioLab.Normalization.normalize_with_0!(co) setup = (co = copy($nu))

end

# ---- #

for (nu, re) in zip(NU_, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1], [0 0.4 0.8; 0.2 0.6 1]))

    co = copy(nu)

    BioLab.Normalization.normalize_with_01!(co)

    @test co == re

    # 10.667 ns (0 allocations: 0 bytes)
    # 12.262 ns (0 allocations: 0 bytes)
    # 16.642 ns (0 allocations: 0 bytes)
    @btime BioLab.Normalization.normalize_with_01!(co) setup = (co = copy($nu))

end

# ---- #

for (nu, re) in zip(
    NU_,
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

    co = copy(nu)

    BioLab.Normalization.normalize_with_sum!(co)

    @test co == re

    # 7.167 ns (0 allocations: 0 bytes)
    # 10.208 ns (0 allocations: 0 bytes)
    @btime BioLab.Normalization.normalize_with_sum!(co) setup = (co = copy($nu))

end

# ---- #

for (nu, re) in zip(
    NU_,
    (
        [0.5, 0.7310585786300049, 0.8807970779778824],
        [0.2689414213699951, 0.5, 0.5825702064623146, 0.7310585786300049],
        [
            0.7310585786300049 0.9525741268224333 0.9933071490757152
            0.8807970779778824 0.9820137900379085 0.9975273768433652
        ],
    ),
)

    co = copy(nu)

    BioLab.Normalization.normalize_with_logistic!(co)

    @test co == re

    # 10.667 ns (0 allocations: 0 bytes)
    # 12.303 ns (0 allocations: 0 bytes)
    # 16.616 ns (0 allocations: 0 bytes)
    @btime BioLab.Normalization.normalize_with_01!(co) setup = (co = copy($nu))

end

# ---- #

const ARR_ = ([-1, 0, 0, 1, 1, 1, 2], [-1 0 1 2; 0 1 1 3])

# ---- #

for (nu, re) in zip(ARR_, ([1, 2, 2, 3, 3, 3, 4], [1 2 3 4; 2 3 3 5]))

    co = copy(nu)

    BioLab.Normalization.normalize_with_1223!(co)

    @test co == re

    # 253.758 ns (2 allocations: 224 bytes)
    # 320.052 ns (6 allocations: 432 bytes)
    @btime BioLab.Normalization.normalize_with_1223!(co) setup = (co = copy($nu))

end

# ---- #

for (nu, re) in zip(ARR_, ([1, 2, 2, 4, 4, 4, 7], [1 2 4 7; 2 4 4 8]))

    co = copy(nu)

    BioLab.Normalization.normalize_with_1224!(co)

    @test co == re

    # 251.995 ns (2 allocations: 224 bytes)
    # 324.631 ns (6 allocations: 432 bytes)
    @btime BioLab.Normalization.normalize_with_1224!(co) setup = (co = copy($nu))

end

# ---- #

for (nu, re) in zip(ARR_, ([1, 2.5, 2.5, 5, 5, 5, 7], [1 2.5 5 7; 2.5 5 5 8]))

    co = float.(nu)

    BioLab.Normalization.normalize_with_125254!(co)

    @test co == re

    # 256.456 ns (2 allocations: 224 bytes)
    # 326.849 ns (6 allocations: 432 bytes)
    @btime BioLab.Normalization.normalize_with_125254!(co) setup = (co = float.($nu))

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

    @test isapprox(co, re; atol = 1e-5)

    # 71.673 ns (0 allocations: 0 bytes)
    # 21.899 ns (0 allocations: 0 bytes)
    # 28.908 ns (0 allocations: 0 bytes)
    # 69.345 ns (0 allocations: 0 bytes)
    # 3.130 μs (24 allocations: 1.31 KiB)
    # 3.162 μs (24 allocations: 1.31 KiB)
    # 3.182 μs (24 allocations: 1.31 KiB)
    @btime foreach($fu, eachcol(co)) setup = (co = copy($MA))

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

    @test isapprox(co, re; atol = 1e-5)

    # 71.612 ns (0 allocations: 0 bytes)
    # 21.900 ns (0 allocations: 0 bytes)
    # 28.811 ns (0 allocations: 0 bytes)
    # 69.373 ns (0 allocations: 0 bytes)
    # 3.130 μs (24 allocations: 1.31 KiB)
    # 3.135 μs (24 allocations: 1.31 KiB)
    # 3.208 μs (24 allocations: 1.31 KiB)
    @btime foreach($fu, eachrow(co)) setup = (co = copy($MA))

end
