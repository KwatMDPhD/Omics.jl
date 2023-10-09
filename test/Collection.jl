using Test: @test

using BioLab

# ---- #

for (an_, re) in (
    ((1, 2, 2, 3, 3, 3, 4), [1, 2, 3, 4]),
    ((4, 3, 3, 3, 2, 2, 1), [1, 2, 3, 4]),
    (('a', 'b', 'b', 'c', 'c', 'c', 'd'), ['a', 'b', 'c', 'd']),
    (('c', 'c', 'c', 'b', 'b', 'a'), ['a', 'b', 'c']),
)

    for an2_ in (an_, collect(an_))

        @test BioLab.Collection.unique_sort(an2_) == re

        # 134.761 ns (6 allocations: 544 bytes)
        # 135.739 ns (6 allocations: 544 bytes)
        # 136.073 ns (6 allocations: 544 bytes)
        # 136.741 ns (6 allocations: 544 bytes)
        # 137.780 ns (6 allocations: 448 bytes)
        # 139.327 ns (6 allocations: 448 bytes)
        # 129.703 ns (6 allocations: 448 bytes)
        # 130.521 ns (6 allocations: 448 bytes)
        #@btime BioLab.Collection.unique_sort($an2_)

    end

end

# ---- #

for (an_, re) in (
    (('a', 'b', 'c'), Dict('a' => 1, 'b' => 2, 'c' => 3)),
    (('c', 'b', 'a'), Dict('a' => 3, 'b' => 2, 'c' => 1)),
)

    for an2_ in (an_, collect(an_))

        @test BioLab.Collection.map_index(an2_) == re

        # 100.996 ns (4 allocations: 480 bytes)
        # 102.304 ns (4 allocations: 480 bytes)
        # 101.007 ns (4 allocations: 480 bytes)
        # 102.437 ns (4 allocations: 480 bytes)
        #@btime BioLab.Collection.map_index($an2_)

    end

end

# ---- #

for (an_, re) in (((NaN,), (NaN, NaN)), ((-1, 1), (-1, 1)), ((-1, -2), (-2, -1)), ((1, 2), (1, 2)))

    for an2_ in (an_, collect(an_))

        @test isequal(BioLab.Collection.get_minimum_maximum(an2_), re)

        # 1.500 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        # 1.500 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        # 1.458 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        # 1.458 ns (0 allocations: 0 bytes)
        # 1.792 ns (0 allocations: 0 bytes)
        #@btime BioLab.Collection.get_minimum_maximum($an2_)

    end

end

# ---- #

for (an_, re) in (
    ((1, 2, 2, 3, 3, 3, 4), "3 3.\n2 2.\n1 4.\n1 1."),
    ((4, 3, 3, 3, 2, 2, 1), "3 3.\n2 2.\n1 4.\n1 1."),
    (('a', 'b', 'b', 'c', 'c', 'c', 'd'), "3 c.\n2 b.\n1 a.\n1 d."),
    (('c', 'c', 'c', 'b', 'b', 'a'), "3 c.\n2 b.\n1 a."),
)

    for an2_ in (an_, collect(an_))

        @test BioLab.Collection.count_sort_string(an2_) == re

        # 8.361 μs (64 allocations: 4.06 KiB)
        # 8.403 μs (64 allocations: 4.06 KiB)
        # 8.333 μs (64 allocations: 4.06 KiB)
        # 8.361 μs (64 allocations: 4.06 KiB)
        # 8.194 μs (55 allocations: 3.47 KiB)
        # 8.194 μs (55 allocations: 3.47 KiB)
        # 7.989 μs (50 allocations: 3.20 KiB)
        # 7.986 μs (50 allocations: 3.20 KiB)
        #@btime BioLab.Collection.count_sort_string($an2_)

    end

end
