using Test: @test

using Nucleus

# ---- #

using OrderedCollections: OrderedDict

using Random: seed!

# ---- #

for (an_, re) in (
    ([1, 2, 2, 3, 3, 3, 4], "1 1.\n1 4.\n2 2.\n3 3.\n"),
    ([4, 3, 3, 3, 2, 2, 1], "1 1.\n1 4.\n2 2.\n3 3.\n"),
    (['a', 'b', 'b', 'c', 'c', 'c', 'd'], "1 a.\n1 d.\n2 b.\n3 c.\n"),
    (['c', 'c', 'c', 'b', 'b', 'a'], "1 a.\n2 b.\n3 c.\n"),
)

    @test Nucleus.Collection.count_sort_string(an_) === re

    # 2.102 μs (62 allocations: 4.00 KiB)
    # 2.069 μs (62 allocations: 4.00 KiB)
    # 2.245 μs (53 allocations: 3.41 KiB)
    # 2.028 μs (48 allocations: 3.13 KiB)
    #@btime Nucleus.Collection.count_sort_string($an_)

end

# ---- #

Nucleus.Collection.log_unique(
    ["Name 1", "Name 2", "Name 3", "Name 4"],
    [
        ['A', 'B', 'C', 'D'],
        ['A', 'A', 'B', 'B', 'C', 'C', 'D', 'D'],
        ['A', 'B', 'B', 'C', 'C', 'C', 'D', 'D', 'D', 'D'],
        ['A', 'A', 'A', 'A', 'B', 'B', 'B', 'C', 'C', 'D'],
    ],
)

# ---- #

for (an_, re) in (([NaN], (NaN, NaN)), ([-1, 1], (-1, 1)), ([-1, -2], (-2, -1)), ([1, 2], (1, 2)))

    @test Nucleus.Collection.get_minimum_maximum(an_) === re

    # 1.791 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 1.750 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Collection.get_minimum_maximum($an_)

end

# ---- #

for (an_, re) in (
    (['a', 'b', 'b', 'c', 'c', 'c'], OrderedDict('a' => [1], 'b' => [2, 3], 'c' => [4, 5, 6])),
    (
        ['c', 'b', 'a', 'a', 'a', 'b', 'b', 'c', 'c'],
        OrderedDict('c' => [1, 8, 9], 'b' => [2, 6, 7], 'a' => [3, 4, 5]),
    ),
    ([1, 2, 3, 3, 2, 1], OrderedDict(1 => [1, 6], 2 => [2, 5], 3 => [3, 4])),
)

    an_id_ = Nucleus.Collection.map_index2(an_)

    @test typeof(an_id_) === typeof(re)

    @test an_id_ == re

    # 412.271 ns (13 allocations: 992 bytes)
    # 444.025 ns (13 allocations: 992 bytes)
    # 421.065 ns (13 allocations: 1.00 KiB)
    #@btime Nucleus.Collection.map_index2($an_)

end

# ---- #

const RE = [
    1 0 0
    0 1 0
    0 0 1
]

# ---- #

for (a1_, a2_) in (
    (['1', '2', '3'], ['1', '2', '3']),
    ([1, 2, 3], [1, 2, 3]),
    ([3, 2, 1], [3, 2, 1]),
    ([10, 20, 30], [10, 20, 30]),
    ([30, 20, 10], [30, 20, 10]),
)

    @test Nucleus.Collection.count(a1_, a2_) == RE

    # 680.195 ns (21 allocations: 1.94 KiB)
    # 635.911 ns (21 allocations: 2.25 KiB)
    # 635.417 ns (21 allocations: 2.25 KiB)
    # 636.405 ns (21 allocations: 2.25 KiB)
    # 635.965 ns (21 allocations: 2.25 KiB)
    #@btime Nucleus.Collection.count($a1_, $a2_)

end

# ---- #

for nr in (10, 100, 1000, 10000)

    it_ = 1:10

    seed!(20231128)

    a1_ = rand(it_, nr)

    a2_ = rand(it_, nr)

    # 800.363 ns (21 allocations: 2.52 KiB)
    # 1.800 μs (23 allocations: 3.66 KiB)
    # 10.750 μs (23 allocations: 3.66 KiB)
    # 101.083 μs (23 allocations: 3.66 KiB)
    #@btime Nucleus.Collection.count($a1_, $a2_)

end
