using Test: @test

using BioLab

# ---- #

const AR_ = ([0.0, 1, 2], [-1, 0, 0.3333333333333333, 1], Matrix(reshape(1.0:6, 2, 3)))

# ---- #

for (ar, re) in zip(AR_, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1], [0 0.4 0.8; 0.2 0.6 1]))

    co = copy(ar)

    BioLab.Normalization.normalize_with_01!(co)

    @test co == re

    # 18.830 ns (0 allocations: 0 bytes)
    # 24.089 ns (0 allocations: 0 bytes)
    # 34.121 ns (0 allocations: 0 bytes)
    #@btime BioLab.Normalization.normalize_with_01!(co) setup = (co = copy($ar))

end

# ---- #

for (ar, re) in zip(
    AR_,
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

    BioLab.Normalization.normalize_with_0!(co)

    @test co == re

    # 25.216 ns (0 allocations: 0 bytes)
    # 26.788 ns (0 allocations: 0 bytes)
    # 29.648 ns (0 allocations: 0 bytes)
    #@btime BioLab.Normalization.normalize_with_0!(co) setup = (co = copy($ar))

end

# ---- #

for (ar, re) in zip(
    AR_[[1, 3]],
    (
        [0, 0.3333333333333333, 0.6666666666666666],
        [
            0.047619047619047616 0.14285714285714285 0.23809523809523808
            0.09523809523809523 0.19047619047619047 0.2857142857142857
        ],
    ),
)

    co = copy(ar)

    BioLab.Normalization.normalize_with_sum!(co)

    @test co == re

    # 7.167 ns (0 allocations: 0 bytes)
    # 10.218 ns (0 allocations: 0 bytes)
    #@btime BioLab.Normalization.normalize_with_sum!(co) setup = (co = copy($ar))

end

# ---- #

const ARR_ = ([-1, 0, 0, 1, 1, 1, 2], [-1 0 1 2; 0 1 1 3])

# ---- #

for (ar, re) in zip(ARR_, ([1, 2, 2, 3, 3, 3, 4], [1 2 3 4; 2 3 3 5]))

    co = copy(ar)

    BioLab.Normalization.normalize_with_1223!(co)

    @test co == re

    # 240.209 ns (2 allocations: 224 bytes)
    # 282.834 ns (6 allocations: 432 bytes)
    #@btime BioLab.Normalization.normalize_with_1223!(co) setup = (co = copy($ar))

end

# ---- #

for (ar, re) in zip(ARR_, ([1, 2, 2, 4, 4, 4, 7], [1 2 4 7; 2 4 4 8]))

    co = copy(ar)

    BioLab.Normalization.normalize_with_1224!(co)

    @test co == re

    # 240.423 ns (2 allocations: 224 bytes)
    # 283.424 ns (6 allocations: 432 bytes)
    #@btime BioLab.Normalization.normalize_with_1224!(co) setup = (co = copy($ar))

end

# ---- #

for (ar, re) in zip(ARR_, ([1, 2.5, 2.5, 5, 5, 5, 7], [1 2.5 5 7; 2.5 5 5 8]))

    co = float.(ar)

    BioLab.Normalization.normalize_with_125254!(co)

    @test co == re

    # 247.389 ns (2 allocations: 224 bytes)
    # 296.206 ns (6 allocations: 432 bytes)
    #@btime BioLab.Normalization.normalize_with_125254!(co) setup = (co = float.($ar))

end

# ---- #

const FU_ = (
    BioLab.Normalization.normalize_with_01!,
    BioLab.Normalization.normalize_with_0!,
    BioLab.Normalization.normalize_with_sum!,
    BioLab.Normalization.normalize_with_1223!,
    BioLab.Normalization.normalize_with_1224!,
    BioLab.Normalization.normalize_with_125254!,
)

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

    # 54.865 ns (0 allocations: 0 bytes)
    # 81.436 ns (0 allocations: 0 bytes)
    # 29.983 ns (0 allocations: 0 bytes)
    # 3.146 μs (24 allocations: 1.31 KiB)
    # 3.151 μs (24 allocations: 1.31 KiB)
    # 272.213 ns (8 allocations: 768 bytes)
    #@btime foreach($fu, eachcol(co)) setup = (co = copy($MA))

end

# ---- #

for (fu, re) in zip(
    FU_,
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

    # 55.145 ns (0 allocations: 0 bytes)
    # 81.996 ns (0 allocations: 0 bytes)
    # 28.727 ns (0 allocations: 0 bytes)
    # 257.172 ns (8 allocations: 768 bytes)
    # 257.359 ns (8 allocations: 768 bytes)
    # 276.489 ns (8 allocations: 768 bytes)
    #@btime foreach($fu, eachrow(co)) setup = (co = copy($MA))

end
