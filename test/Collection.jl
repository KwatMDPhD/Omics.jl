using Test: @test

using Nucleus

# ---- #

using OrderedCollections: OrderedDict

using Random: seed!

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

    # 305.612 ns (13 allocations: 992 bytes)
    # 340.820 ns (13 allocations: 992 bytes)
    # 318.133 ns (13 allocations: 1.00 KiB)
    #@btime Nucleus.Collection.map_index2($an_)

end

# ---- #

const RE = [
    1 0 0
    0 1 0
    0 0 1
]

# ---- #

for (an1_, an2_) in (
    (['1', '2', '3'], ['1', '2', '3']),
    ([1, 2, 3], [1, 2, 3]),
    ([3, 2, 1], [3, 2, 1]),
    ([10, 20, 30], [10, 20, 30]),
    ([30, 20, 10], [30, 20, 10]),
)

    @test Nucleus.Collection.count(an1_, an2_) == RE

    # 505.208 ns (21 allocations: 1.94 KiB)
    # 447.601 ns (21 allocations: 2.25 KiB)
    # 447.808 ns (21 allocations: 2.25 KiB)
    # 447.813 ns (21 allocations: 2.25 KiB)
    # 448.391 ns (21 allocations: 2.25 KiB)
    #@btime Nucleus.Collection.count($an1_, $an2_)

end

# ---- #

for n_ra in (10, 100, 1000, 10000)

    it_ = 1:10

    seed!(20231128)

    an1_ = rand(it_, n_ra)

    an2_ = rand(it_, n_ra)

    # 620.640 ns (21 allocations: 2.52 KiB)
    # 1.625 μs (23 allocations: 3.66 KiB)
    # 10.583 μs (23 allocations: 3.66 KiB)
    # 100.833 μs (23 allocations: 3.66 KiB)
    #@btime Nucleus.Collection.count($an1_, $an2_)

end

# ---- #

for (an_, re) in (
    ([1, 2, 2, 3, 3, 3, 4], "3 3.\n2 2.\n1 4.\n1 1.\n"),
    ([4, 3, 3, 3, 2, 2, 1], "3 3.\n2 2.\n1 4.\n1 1.\n"),
    (['a', 'b', 'b', 'c', 'c', 'c', 'd'], "3 c.\n2 b.\n1 a.\n1 d.\n"),
    (['c', 'c', 'c', 'b', 'b', 'a'], "3 c.\n2 b.\n1 a.\n"),
)

    @test Nucleus.Collection.count_sort_string(an_) === re

    # 8.333 μs (61 allocations: 3.98 KiB)
    # 8.292 μs (61 allocations: 3.98 KiB)
    # 8.153 μs (52 allocations: 3.39 KiB)
    # 7.948 μs (47 allocations: 3.12 KiB)
    #@btime Nucleus.Collection.count_sort_string($an_)

end
