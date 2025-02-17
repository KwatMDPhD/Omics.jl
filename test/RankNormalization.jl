using Random: seed!

using Test: @test

using Omics

# ---- #

const FL___ = [-1, 0, 0, 1, 1, 1, 2.0],
[1, 2, 3, 4, 5, 6, 7, 8, 9, 100.0],
[
    -1 0 1 2
    0 1 1 3.0
]

# ---- #

for (nu_, re) in zip(
    FL___,
    (
        [1, 2, 2, 3, 3, 3, 4.0],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10.0],
        [
            1 2 3 4
            2 3 3 5.0
        ],
    ),
)

    co = copy(nu_)

    Omics.RankNormalization.do_1223!(co)

    @test co == re

end

# ---- #

for (nu_, re) in zip(
    FL___,
    (
        [1, 2, 2, 4, 4, 4, 7.0],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10.0],
        [
            1 2 4 7
            2 4 4 8.0
        ],
    ),
)

    co = copy(nu_)

    Omics.RankNormalization.do_1224!(co)

    @test co == re

end

# ---- #

for (fl_, re) in zip(
    FL___,
    (
        [1, 2.5, 2.5, 5, 5, 5, 7],
        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10.0],
        [
            1 2.5 5 7
            2.5 5 5 8
        ],
    ),
)

    co = map(float, fl_)

    Omics.RankNormalization.do_125254!(co)

    @test co == re

end

# ---- #

const ZE_ = zeros(10)

const ON_ = ones(10)

for (nu_, qu_, re) in (
    (ZE_, (1,), ON_),
    (ZE_, (0.5, 1), ON_),
    (FL___[2], (1,), ON_),
    (FL___[2], (0.5, 1), [1, 1, 1, 1, 1, 2, 2, 2, 2, 2.0]),
    (FL___[2], (1 / 3, 2 / 3, 1), [1, 1, 1, 1, 2, 2, 3, 3, 3, 3.0]),
)

    co = copy(nu_)

    Omics.RankNormalization.do_quantile!(co, qu_)

    @test co == re

end

# ---- #

# 247.625 μs (9 allocations: 234.56 KiB)
# 247.667 μs (9 allocations: 234.56 KiB)
# 248.750 μs (9 allocations: 234.56 KiB)
# 97.416 μs (3 allocations: 78.19 KiB)

for fu in (
    Omics.RankNormalization.do_1223!,
    Omics.RankNormalization.do_1224!,
    Omics.RankNormalization.do_125254!,
    Omics.RankNormalization.do_quantile!,
)

    for um in (1000, 10000)

        seed!(20250216)

        #@btime $fu($(rand(um)))

    end

end
