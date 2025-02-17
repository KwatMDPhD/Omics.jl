using Random: shuffle!

using Test: @test

using Omics

# ---- #

# 15.865 ns (2 allocations: 80 bytes)
# 16.366 ns (2 allocations: 96 bytes)
# 15.238 ns (2 allocations: 96 bytes)

for (u1, u2, re) in ((5, 1, [1, 5]), (5, 2, [1, 2, 4, 5]), (5, 3, [1, 2, 3, 4, 5]))

    @test Omics.Extreme.ge(u1, u2) == re

    #@btime Omics.Extreme.ge($u1, $u2)

end

# ---- #

const CH_ = shuffle!(collect('a':'z'))

for (an_, um, re) in (
    (CH_, 0, Char[]),
    (CH_, 1, ['a', 'z']),
    (CH_, 2, ['a', 'b', 'y', 'z']),
    (CH_, 13, sort(CH_)),
)

    @test an_[Omics.Extreme.ge(an_, um)] == re

end
