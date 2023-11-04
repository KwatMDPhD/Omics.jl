using Test: @test

using Nucleus

# ---- #

using OrderedCollections: OrderedDict

# ---- #

for (an_, re) in (([NaN], (NaN, NaN)), ([-1, 1], (-1, 1)), ([-1, -2], (-2, -1)), ([1, 2], (1, 2)))

    @test Nucleus.Collection.get_minimum_maximum(an_) === re

    # 1.791 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
    # 1.791 ns (0 allocations: 0 bytes)
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

    an_id_ = Nucleus.Collection.map_index(an_)

    @test typeof(an_id_) === typeof(re)

    @test an_id_ == re

    # 307.440 ns (13 allocations: 992 bytes)
    # 342.553 ns (13 allocations: 992 bytes)
    # 317.597 ns (13 allocations: 1.00 KiB)
    #@btime Nucleus.Collection.map_index($an_)

end

# ---- #

for (an_, re) in (
    ([1, 2, 2, 3, 3, 3, 4], "3 3.\n2 2.\n1 4.\n1 1.\n"),
    ([4, 3, 3, 3, 2, 2, 1], "3 3.\n2 2.\n1 4.\n1 1.\n"),
    (['a', 'b', 'b', 'c', 'c', 'c', 'd'], "3 c.\n2 b.\n1 a.\n1 d.\n"),
    (['c', 'c', 'c', 'b', 'b', 'a'], "3 c.\n2 b.\n1 a.\n"),
)

    @test Nucleus.Collection.count_sort_string(an_) === re

    # 8.139 μs (61 allocations: 3.98 KiB)
    # 8.111 μs (61 allocations: 3.98 KiB)
    # 7.986 μs (52 allocations: 3.39 KiB)
    # 7.761 μs (47 allocations: 3.12 KiB)
    #@btime Nucleus.Collection.count_sort_string($an_)

end
