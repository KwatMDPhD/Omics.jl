using Test: @test

using BioLab

# ---- #

const ID_ = Int[]

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

    # 18.662 ns (1 allocation: 64 bytes)
    # 18.639 ns (1 allocation: 64 bytes)
    # 58.604 ns (3 allocations: 192 bytes)
    # 59.978 ns (3 allocations: 208 bytes)
    # 19.915 ns (1 allocation: 96 bytes)
    # 19.893 ns (1 allocation: 96 bytes)
    #@btime BioLab.Rank.get_extreme($n, $n_ex)

end

# ---- #

const IT_ = [20, 40, 60, 50, 30, 10]

# ---- #

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

# ---- #

for (an_, n_ex, re) in (
    (ID_, 0, ID_),
    (ID_, 1, ID_),
    (IT_, 0, ID_),
    (IT_, 1, [10, 60]),
    (IT_, 2, [10, 20, 50, 60]),
    (IT_, lastindex(IT_) + 1, sort(IT_)),
    (CH_, 0, Char[]),
    (CH_, 1, ['a', 'z']),
    (CH_, 2, ['a', 'b', 'y', 'z']),
    (CH_, lastindex(CH_) + 1, sort(CH_)),
)

    @test view(an_, BioLab.Rank.get_extreme(an_, n_ex)) == re

    # 59.997 ns (3 allocations: 192 bytes)
    # 59.954 ns (3 allocations: 192 bytes)
    # 122.611 ns (5 allocations: 368 bytes)
    # 125.232 ns (5 allocations: 400 bytes)
    # 130.663 ns (5 allocations: 464 bytes)
    # 90.387 ns (3 allocations: 336 bytes)
    # 315.751 ns (6 allocations: 800 bytes)
    # 321.528 ns (6 allocations: 832 bytes)
    # 323.645 ns (6 allocations: 896 bytes)
    # 305.556 ns (4 allocations: 1.06 KiB)
    #@btime BioLab.Rank.get_extreme($an_, $n_ex)

end
