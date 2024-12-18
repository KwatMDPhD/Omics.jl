using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

const ID_ = UInt[]

# ---- #

# 6.791 ns (1 allocation: 32 bytes)
# 6.791 ns (1 allocation: 32 bytes)
# 8.967 ns (1 allocation: 32 bytes)
# 15.865 ns (2 allocations: 80 bytes)
# 15.281 ns (2 allocations: 96 bytes)
# 15.238 ns (2 allocations: 96 bytes)
for (ua, ue, re) in (
    (0, 0, ID_),
    (0, 1, ID_),
    (1, 0, ID_),
    (5, 1, [1, 5]),
    (5, 3, [1, 2, 3, 4, 5]),
    (5, 6, [1, 2, 3, 4, 5]),
)

    @test Omics.Rank.get_extreme(ua, ue) == re

    #@btime Omics.Rank.get_extreme($ua, $ue)

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

# 20.186 ns (3 allocations: 96 bytes)
# 19.642 ns (3 allocations: 96 bytes)
# 46.843 ns (4 allocations: 176 bytes)
# 63.328 ns (6 allocations: 272 bytes)
# 65.986 ns (6 allocations: 304 bytes)
# 68.593 ns (6 allocations: 336 bytes)
# 229.396 ns (6 allocations: 608 bytes)
# 233.002 ns (8 allocations: 704 bytes)
# 249.670 ns (8 allocations: 736 bytes)
# 247.361 ns (8 allocations: 1.06 KiB)
for (an_, ue, re) in (
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

    @test an_[Omics.Rank.get_extreme(an_, ue)] == re

    #@btime Omics.Rank.get_extreme($an_, $ue)

end
