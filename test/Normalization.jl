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

    # 24.417 ns (0 allocations: 0 bytes)
    # 26.375 ns (0 allocations: 0 bytes)
    # 29.708 ns (0 allocations: 0 bytes)
    #@btime Omics.Normalization.normalize_with_0!($co)

end

# ---- #

for (nu_, re) in
    zip(NU___, ([0, 0.5, 1], [0, 0.5, 0.6666666666666666, 1], [0 0.4 0.8; 0.2 0.6 1]))

    co = copy(nu_)

    Omics.Normalization.normalize_with_01!(co)

    @test co == re

    # 21.000 ns (0 allocations: 0 bytes)
    # 24.866 ns (0 allocations: 0 bytes)
    # 34.631 ns (0 allocations: 0 bytes)
    #@btime Omics.Normalization.normalize_with_01!($co)

end

# ---- #

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

    # 8.333 ns (0 allocations: 0 bytes)
    # 9.833 ns (0 allocations: 0 bytes)
    #@btime Omics.Normalization.normalize_with_sum!($co)

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

    Omics.Normalization.normalize_with_logistic!(co)

    @test co == re

    # 22.234 ns (0 allocations: 0 bytes)
    # 24.740 ns (0 allocations: 0 bytes)
    # 24.180 ns (0 allocations: 0 bytes)
    #@btime Omics.Normalization.normalize_with_logistic!($co)

end

# ---- #

const NR___ = [-1, 0, 0, 1, 1, 1, 2], [-1 0 1 2; 0 1 1 3]

# ---- #

for (nu_, re) in zip(NR___, ([1, 2, 2, 3, 3, 3, 4], [1 2 3 4; 2 3 3 5]))

    co = copy(nu_)

    Omics.Normalization.normalize_with_1223!(co)

    @test co == re

    # 55.118 ns (4 allocations: 224 bytes)
    # 246.474 ns (6 allocations: 352 bytes)
    #@btime Omics.Normalization.normalize_with_1223!($co)

end

# ---- #

for (nu_, re) in zip(NR___, ([1, 2, 2, 4, 4, 4, 7], [1 2 4 7; 2 4 4 8]))

    co = copy(nu_)

    Omics.Normalization.normalize_with_1224!(co)

    @test co == re

    # 55.118 ns (4 allocations: 224 bytes)
    # 246.398 ns (6 allocations: 352 bytes)
    #@btime Omics.Normalization.normalize_with_1224!($co)

end

# ---- #

for (nu_, re) in zip(NR___, ([1, 2.5, 2.5, 5, 5, 5, 7], [1 2.5 5 7; 2.5 5 5 8]))

    co = map(float, nu_)

    Omics.Normalization.normalize_with_125254!(co)

    @test co == re

    # 64.498 ns (4 allocations: 224 bytes)
    # 262.208 ns (6 allocations: 352 bytes)
    #@btime Omics.Normalization.normalize_with_125254!($co)

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

        Omics.Normalization.normalize_with_quantile!(co, qu_)

        @test co == popfirst!(RE_)

        # 58.919 ns (2 allocations: 144 bytes)
        # 58.918 ns (2 allocations: 144 bytes)
        # 59.766 ns (2 allocations: 144 bytes)
        # 58.918 ns (2 allocations: 144 bytes)
        # 60.359 ns (2 allocations: 144 bytes)
        # 60.359 ns (2 allocations: 144 bytes)
        # 60.378 ns (2 allocations: 144 bytes)
        # 60.359 ns (2 allocations: 144 bytes)
        # 60.463 ns (2 allocations: 144 bytes)
        # 60.359 ns (2 allocations: 144 bytes)
        # 60.374 ns (2 allocations: 144 bytes)
        # 60.336 ns (2 allocations: 144 bytes)
        # 60.336 ns (2 allocations: 144 bytes)
        # 63.201 ns (2 allocations: 144 bytes)
        # 61.968 ns (2 allocations: 144 bytes)
        # 61.906 ns (2 allocations: 144 bytes)
        # 68.476 ns (2 allocations: 144 bytes)
        # 74.255 ns (2 allocations: 144 bytes)
        # 72.597 ns (2 allocations: 144 bytes)
        # 72.970 ns (2 allocations: 144 bytes)
        # 68.705 ns (2 allocations: 144 bytes)
        # 73.869 ns (2 allocations: 144 bytes)
        # 72.937 ns (2 allocations: 144 bytes)
        # 72.949 ns (2 allocations: 144 bytes)
        # 68.833 ns (2 allocations: 144 bytes)
        # 74.460 ns (2 allocations: 144 bytes)
        # 72.713 ns (2 allocations: 144 bytes)
        # 72.928 ns (2 allocations: 144 bytes)
        #@btime Omics.Normalization.normalize_with_quantile!($co)

    end

end
