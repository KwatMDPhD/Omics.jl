using Test: @test

using BioLab

# ---- #

for (co, re) in (
    ((1, 2, 2, 3, 3, 3, 4), [1, 2, 3, 4]),
    ((4, 3, 3, 3, 2, 2, 1), [1, 2, 3, 4]),
    (('a', 'b', 'b', 'c', 'c', 'c', 'd'), ['a', 'b', 'c', 'd']),
    (('c', 'c', 'c', 'b', 'b', 'a'), ['a', 'b', 'c']),
)

    for co2 in (co, collect(co))

        @test BioLab.Collection.unique_sort(co2) == re

        # 131.480 ns (6 allocations: 544 bytes)
        # 132.806 ns (6 allocations: 544 bytes)
        # 132.709 ns (6 allocations: 544 bytes)
        # 133.952 ns (6 allocations: 544 bytes)
        # 135.393 ns (6 allocations: 448 bytes)
        # 135.851 ns (6 allocations: 448 bytes)
        # 128.156 ns (6 allocations: 448 bytes)
        # 127.333 ns (6 allocations: 448 bytes)
        @btime BioLab.Collection.unique_sort($co2)

    end

end

# ---- #

for (co, re) in (
    (('a', 'b', 'c'), Dict('a' => 1, 'b' => 2, 'c' => 3)),
    (('c', 'b', 'a'), Dict('a' => 3, 'b' => 2, 'c' => 1)),
)

    for co2 in (co, collect(co))

        @test BioLab.Collection.map_index(co2) == re

        # 98.920 ns (4 allocations: 480 bytes)
        # 103.258 ns (4 allocations: 480 bytes)
        # 99.277 ns (4 allocations: 480 bytes)
        # 102.482 ns (4 allocations: 480 bytes)
        @btime BioLab.Collection.map_index($co2)

    end

end

# ---- #

for (co, re) in (((NaN,), (NaN, NaN)), ((-1, 1), (-1, 1)), ((-1, -2), (-2, -1)), ((1, 2), (1, 2)))

    for co2 in (co, collect(co))

        @test isequal(BioLab.Collection.get_minimum_maximum(co2), re)

        # 1.500 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        # 1.500 ns (0 allocations: 0 bytes)
        # 1.792 ns (0 allocations: 0 bytes)
        # 1.500 ns (0 allocations: 0 bytes)
        # 1.792 ns (0 allocations: 0 bytes)
        # 1.500 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        @btime BioLab.Collection.get_minimum_maximum($co2)

    end

end

# ---- #

for co in (
    (1, 2, 2, 3, 3, 3, 4),
    (4, 3, 3, 3, 2, 2, 1),
    ('a', 'b', 'b', 'c', 'c', 'c', 'd'),
    ('c', 'c', 'c', 'b', 'b', 'a'),
)

    for co2 in (co, collect(co))

        @test BioLab.Collection.count_sort_string(co2)

    end

end
