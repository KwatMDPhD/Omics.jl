using Test: @test

using BioLab

# ---- #

for (ra, re) in zip(
    0:28,
    (
        0.0,
        0.1,
        0.2,
        0.3,
        0.4,
        0.5,
        0.6,
        0.7,
        0.8,
        0.9,
        0.91,
        0.92,
        0.93,
        0.94,
        0.95,
        0.96,
        0.97,
        0.98,
        0.99,
        0.991,
        0.992,
        0.993,
        0.994,
        0.995,
        0.996,
        0.997,
        0.998,
        0.999,
        0.9991,
    ),
)

    @test BioLab.Rank.rank_in_fraction(ra) === re

end

# ---- #

const ID_ = Vector{Int}()

# ---- #

for (n, n_ex, re) in (
    (0, 0, ID_),
    (0, 1, ID_),
    (1, 0, ID_),
    (5, 1, [1, 5]),
    (5, 3, [1, 2, 3, 4, 5]),
    (5, 6, [1, 2, 3, 4, 5]),
)

    @test BioLab.Rank.get_extreme(n, n_ex) == re

end

# ---- #

const IT_ = [20, 40, 60, 50, 30, 10]

const CH_ = [
    'b',
    'd',
    'f',
    'h',
    'j',
    'l',
    'n',
    'p',
    'r',
    't',
    'v',
    'x',
    'z',
    'y',
    'w',
    'u',
    's',
    'q',
    'o',
    'm',
    'k',
    'i',
    'g',
    'e',
    'c',
    'a',
]

for (an_, n_ex, re) in (
    (ID_, 0, ID_),
    (ID_, 1, ID_),
    (IT_, 0, ID_),
    (IT_, 1, [10, 60]),
    (IT_, 2, [10, 20, 50, 60]),
    (IT_, length(IT_) + 1, sort(IT_)),
    (CH_, 0, Vector{Char}()),
    (CH_, 1, ['a', 'z']),
    (CH_, 2, ['a', 'b', 'y', 'z']),
    (CH_, length(CH_) + 1, sort(CH_)),
)

    @test view(an_, BioLab.Rank.get_extreme(an_, n_ex)) == re

end

# ---- #

const FL_ = [NaN, 1, NaN, 2, NaN, 3, NaN, 4, NaN, 5]

for (n, re) in ((1, [2, 10]), (2, [2, 4, 8, 10]), (3, [2, 4, 6, 8, 10]))

    @test BioLab.Rank.get_extreme(FL_, n) == re

end
