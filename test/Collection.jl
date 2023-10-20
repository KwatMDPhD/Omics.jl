using Test: @test

using BioLab

# ---- #

for (an_, re) in (((NaN,), (NaN, NaN)), ((-1, 1), (-1, 1)), ((-1, -2), (-2, -1)), ((1, 2), (1, 2)))

    for an2_ in (an_, collect(an_))

        @test BioLab.Collection.get_minimum_maximum(an2_) === re

        # 1.500 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        # 1.458 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        # 1.500 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        # 1.458 ns (0 allocations: 0 bytes)
        # 1.791 ns (0 allocations: 0 bytes)
        #@btime BioLab.Collection.get_minimum_maximum($an2_)

    end

end

# ---- #

for (an_, re) in (
    ((1, 2, 2, 3, 3, 3, 4), "3 3.\n2 2.\n1 4.\n1 1.\n"),
    ((4, 3, 3, 3, 2, 2, 1), "3 3.\n2 2.\n1 4.\n1 1.\n"),
    (('a', 'b', 'b', 'c', 'c', 'c', 'd'), "3 c.\n2 b.\n1 a.\n1 d.\n"),
    (('c', 'c', 'c', 'b', 'b', 'a'), "3 c.\n2 b.\n1 a.\n"),
)

    for an2_ in (an_, collect(an_))

        @test BioLab.Collection.count_sort_string(an2_) === re

        # 8.125 μs (61 allocations: 3.98 KiB)
        # 8.111 μs (61 allocations: 3.98 KiB)
        # 8.125 μs (61 allocations: 3.98 KiB)
        # 8.167 μs (61 allocations: 3.98 KiB)
        # 8.014 μs (52 allocations: 3.39 KiB)
        # 7.972 μs (52 allocations: 3.39 KiB)
        # 7.802 μs (47 allocations: 3.12 KiB)
        # 7.739 μs (47 allocations: 3.12 KiB)
        #@btime BioLab.Collection.count_sort_string($an2_)

    end

end
