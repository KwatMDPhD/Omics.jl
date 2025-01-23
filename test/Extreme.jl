using Test: @test

using Omics

# ---- #

const ID_ = Int[]

# ---- #

# 6.791 ns (1 allocation: 32 bytes)
# 6.792 ns (1 allocation: 32 bytes)
# 8.967 ns (1 allocation: 32 bytes)
# 15.865 ns (2 allocations: 80 bytes)
# 15.238 ns (2 allocations: 96 bytes)
# 15.238 ns (2 allocations: 96 bytes)
for (ua, ue, re) in (
    (0, 0, ID_),
    (0, 1, ID_),
    (1, 0, ID_),
    (5, 1, [1, 5]),
    (5, 3, [1, 2, 3, 4, 5]),
    (5, 6, [1, 2, 3, 4, 5]),
)

    @test Omics.Extreme.ge(ua, ue) == re

    #@btime Omics.Extreme.ge($ua, $ue)

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

# ---- #

# 19.600 ns (3 allocations: 96 bytes)
# 19.581 ns (3 allocations: 96 bytes)
# 47.776 ns (4 allocations: 176 bytes)
# 65.306 ns (6 allocations: 272 bytes)
# 68.635 ns (6 allocations: 304 bytes)
# 69.800 ns (6 allocations: 336 bytes)
# 217.063 ns (6 allocations: 608 bytes)
# 249.137 ns (8 allocations: 704 bytes)
# 247.382 ns (8 allocations: 736 bytes)
# 264.477 ns (8 allocations: 1.06 KiB)
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

    @test an_[Omics.Extreme.ge(an_, ue)] == re

    #@btime Omics.Extreme.ge($an_, $ue)

end
