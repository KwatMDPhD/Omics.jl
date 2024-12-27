using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const NU___ = [0.0, 1, 2],
[-1, 0, 0.3333333333333333, 1],
[
    1.0 3 5
    2 4 6
]

# ---- #

# 24.417 ns (0 allocations: 0 bytes)
# 26.375 ns (0 allocations: 0 bytes)
# 29.708 ns (0 allocations: 0 bytes)
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

    Omics.Normalization.normalize_with_0!(co)

    @test co == re

    #@btime Omics.Normalization.normalize_with_0!($co)

end

# ---- #

# 20.958 ns (0 allocations: 0 bytes)
# 24.991 ns (0 allocations: 0 bytes)
# 34.582 ns (0 allocations: 0 bytes)
for (nu_, re) in
    zip(NU___, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1], [0 0.4 0.8; 0.2 0.6 1]))

    co = copy(nu_)

    Omics.Normalization.normalize_with_01!(co)

    @test co == re

    #@btime Omics.Normalization.normalize_with_01!($co)

end

# ---- #

# 8.583 ns (0 allocations: 0 bytes)
# 9.875 ns (0 allocations: 0 bytes)
for (nu_, re) in zip(
    NU___[[1, 3]],
    (
        [0, 0.3333333333333333, 0.6666666666666666],
        [
            0.047619047619047616 0.14285714285714285 0.23809523809523808
            0.09523809523809523 0.19047619047619047 0.2857142857142857
        ],
    ),
)

    co = copy(nu_)

    Omics.Normalization.normalize_with_sum!(co)

    @test co == re

    #@btime Omics.Normalization.normalize_with_sum!($co)

end

# ---- #

# 21.857 ns (0 allocations: 0 bytes)
# 24.031 ns (0 allocations: 0 bytes)
# 23.510 ns (0 allocations: 0 bytes)
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

    Omics.Normalization.normalize_with_logistic!(co)

    @test co == re

    #@btime Omics.Normalization.normalize_with_logistic!($co)

end

# ---- #

const NR___ = [-1, 0, 0, 1, 1, 1, 2], [-1 0 1 2; 0 1 1 3]

# ---- #

# 53.921 ns (4 allocations: 224 bytes)
# 243.663 ns (6 allocations: 352 bytes)
for (nu_, re) in zip(NR___, ([1, 2, 2, 3, 3, 3, 4], [1 2 3 4; 2 3 3 5]))

    co = copy(nu_)

    Omics.Normalization.normalize_with_1223!(co)

    @test co == re

    #@btime Omics.Normalization.normalize_with_1223!($co)

end

# ---- #

# 53.245 ns (4 allocations: 224 bytes)
# 243.542 ns (6 allocations: 352 bytes)
for (nu_, re) in zip(NR___, ([1, 2, 2, 4, 4, 4, 7], [1 2 4 7; 2 4 4 8]))

    co = copy(nu_)

    Omics.Normalization.normalize_with_1224!(co)

    @test co == re

    #@btime Omics.Normalization.normalize_with_1224!($co)

end

# ---- #

# 62.436 ns (4 allocations: 224 bytes)
# 260.418 ns (6 allocations: 352 bytes)
for (nu_, re) in zip(NR___, ([1, 2.5, 2.5, 5, 5, 5, 7], [1 2.5 5 7; 2.5 5 5 8]))

    co = map(float, nu_)

    Omics.Normalization.normalize_with_125254!(co)

    @test co == re

    #@btime Omics.Normalization.normalize_with_125254!($co)

end

# ---- #

const ON_ = ones(10)

const OI_ = ones(Int, 10)

const RE_ = [
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    ON_,
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    ON_,
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    OI_,
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
    OI_,
    [1.0, 1, 1, 1, 1, 2, 2, 2, 2, 2],
    [1.0, 1, 1, 1, 2, 2, 3, 3, 3, 3],
    [1.0, 1, 2, 2, 3, 3, 4, 4, 5, 5],
]

# 54.653 ns (2 allocations: 144 bytes)
# 54.698 ns (2 allocations: 144 bytes)
# 54.682 ns (2 allocations: 144 bytes)
# 54.695 ns (2 allocations: 144 bytes)
# 54.654 ns (2 allocations: 144 bytes)
# 54.780 ns (2 allocations: 144 bytes)
# 54.682 ns (2 allocations: 144 bytes)
# 54.711 ns (2 allocations: 144 bytes)
# 55.287 ns (2 allocations: 144 bytes)
# 54.695 ns (2 allocations: 144 bytes)
# 54.695 ns (2 allocations: 144 bytes)
# 56.784 ns (2 allocations: 144 bytes)
# 56.245 ns (2 allocations: 144 bytes)
# 59.809 ns (2 allocations: 144 bytes)
# 58.435 ns (2 allocations: 144 bytes)
# 58.435 ns (2 allocations: 144 bytes)
# 322.918 ns (32 allocations: 944 bytes)
# 466.837 ns (47 allocations: 1.31 KiB)
# 441.712 ns (44 allocations: 1.23 KiB)
# 443.606 ns (44 allocations: 1.23 KiB)
# 324.382 ns (32 allocations: 944 bytes)
# 467.005 ns (47 allocations: 1.31 KiB)
# 442.551 ns (44 allocations: 1.23 KiB)
# 443.394 ns (44 allocations: 1.23 KiB)
# 322.605 ns (32 allocations: 944 bytes)
# 467.218 ns (47 allocations: 1.31 KiB)
# 441.919 ns (44 allocations: 1.23 KiB)
# 441.495 ns (44 allocations: 1.23 KiB)
for nu_ in (
    zeros(10),
    fill(0.1, 10),
    ON_,
    collect(0.1:0.1:1),
    collect(1:10),
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 100],
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 1000],
)

    for qu_ in ((0, 1), (0, 0.5, 1), (0, 1 / 3, 2 / 3, 1), (0, 0.2, 0.4, 0.6, 0.8, 1))

        co = copy(nu_)

        Omics.Normalization.normalize_with_quantile!(co, qu_)

        @test co == popfirst!(RE_)

        #@btime Omics.Normalization.normalize_with_quantile!($co)

    end

end
