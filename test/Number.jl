using Test: @test

using Nucleus

# ---- #

const NU_ = (0, -0.000, 0.000, pi)

# ---- #

for (nu, re) in zip(NU_, ("0", "-0", "0", "3.1"))

    @test Nucleus.Number.format2(nu) === re

end

# ---- #

for (nu, re) in zip(NU_, ("0", "-0", "0", "3.142"))

    @test Nucleus.Number.format4(nu) === re

end

# ---- #

const CO_ = (0, 6, 19, 41, 61, 81, 120)

# ---- #

const CA_ = ("0-5", "6-18", "19-40", "41-60", "61-80", "81-")

# ---- #

for nu in (-1, 120)

    @test Nucleus.Error.@is Nucleus.Number.categorize(nu, CO_, CA_)

end

# ---- #

for (nu, re) in (
    (0, CA_[1]),
    (5, CA_[1]),
    (6, CA_[2]),
    (18, CA_[2]),
    (19, CA_[3]),
    (40, CA_[3]),
    (41, CA_[4]),
    (60, CA_[4]),
    (61, CA_[5]),
    (80, CA_[5]),
    (81, CA_[6]),
    (82, CA_[6]),
)

    @test Nucleus.Number.categorize(nu, CO_, CA_) === re

    # 2.709 ns (0 allocations: 0 bytes)
    # 2.750 ns (0 allocations: 0 bytes)
    # 3.041 ns (0 allocations: 0 bytes)
    # 3.041 ns (0 allocations: 0 bytes)
    # 3.375 ns (0 allocations: 0 bytes)
    # 3.375 ns (0 allocations: 0 bytes)
    # 3.666 ns (0 allocations: 0 bytes)
    # 3.666 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Number.categorize($nu, CO_, CA_)

end

# ---- #

for (st, re) in (
    ("0", 0),
    ("-0.0", 0),
    ("0.0", 0),
    ("0.1", 0.1),
    (".1", 0.1),
    ('a', 'a'),
    ("Aa", "Aa"),
    ("1/2", "1/2"),
)

    @test Nucleus.Number.try_parse(st) === re

    # 41.498 ns (0 allocations: 0 bytes)
    # 47.228 ns (0 allocations: 0 bytes)
    # 46.596 ns (0 allocations: 0 bytes)
    # 181.375 μs (2 allocations: 48 bytes)
    # 181.542 μs (2 allocations: 48 bytes)
    # 369.667 μs (8 allocations: 352 bytes)
    # 473.333 μs (20 allocations: 848 bytes)
    # 473.541 μs (20 allocations: 848 bytes)
    #@btime Nucleus.Number.try_parse($st)

end

# ---- #

for an_ in ([-1, 1, 2, 0], ['a', 'b', 'c', 'd'], ['a', 'c', 'd', 'b'])

    @test Nucleus.Number.integize(an_) == [1, 2, 3, 4]

    # 256.986 ns (11 allocations: 1.16 KiB)
    # 313.481 ns (11 allocations: 1.00 KiB)
    # 315.779 ns (11 allocations: 1.00 KiB)
    #@btime Nucleus.Number.integize($an_)

end
