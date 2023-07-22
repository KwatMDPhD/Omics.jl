using Test: @test

using BioLab

# ---- #

const EM = Vector{Int}()

# ---- #

for (n, n_ex, re) in (
    (0, 0, EM),
    (0, 1, EM),
    (1, 0, EM),
    (5, 1, [1, 5]),
    (5, 3, [1, 2, 3, 4, 5]),
    (5, 6, [1, 2, 3, 4, 5]),
)

    @test BioLab.Vector.get_extreme(n, n_ex) == re

end

# ---- #

const CO1 = [20, 40, 60, 50, 30, 10]

const CO2 = [
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
    (EM, 0, EM),
    (EM, 1, EM),
    (CO1, 0, EM),
    (CO1, 1, [10, 60]),
    (CO1, 2, [10, 20, 50, 60]),
    (CO1, length(CO1) + 1, sort(CO1)),
    (CO2, 0, Vector{Char}()),
    (CO2, 1, ['a', 'z']),
    (CO2, 2, ['a', 'b', 'y', 'z']),
    (CO2, length(CO2) + 1, sort(CO2)),
)

    @test view(an_, BioLab.Vector.get_extreme(an_, n_ex)) == re

end

# ---- #

const FL_ = [NaN, 1, NaN, 2, NaN, 3, NaN, 4, NaN, 5]

for (n, re) in ((1, [2, 10]), (2, [2, 4, 8, 10]), (3, [2, 4, 6, 8, 10]))

    @test BioLab.Vector.get_extreme(FL_, n) == re

end
