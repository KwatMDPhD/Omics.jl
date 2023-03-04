include("_.jl")

for (ar1, ar2) in (([], ()), ([1, 2], [""]), ([3 4], ["a", "b"]))

    @test @is_error BioLab.Array.error_size(ar1, ar2)

end

for ar_ in (([], []), ([1, 2], ["", "a"]), ([3, 4], ["b", "c"], ['d', 'e']), ([], [], []))

    @test !@is_error BioLab.Array.error_size(ar_)

end

for ar_ in (([1], [2.0], [3]), ([1], [2.0], ['a']))

    BioLab.print_header(ar_)

    # @code_warntype BioLab.Array.error_size(ar_)

    # 3.666 ns (0 allocations: 0 bytes)
    # 38.471 ns (0 allocations: 0 bytes)
    # @btime BioLab.Array.error_size($ar_)

end

for an_ in ([1.0, 1, 2.0], [1 1 2], ["a", "a", "b"], [1 2.0; 2 3])

    @test @is_error BioLab.Array.error_duplicate(an_)

end

for an_ in ((), [], [1, 2, 3], ['a', 'b', 'c'], [1 2; 3 4])

    @test !@is_error BioLab.Array.error_duplicate(an_)

end

for an_ in (
    (1.0, 2.0, 3.0, 4.0),
    [1.0, 2.0, 3.0, 4.0],
    (1, 2, 3, 4),
    [1, 2, 3, 4],
    (1, 2.0, 3, 4.0),
    [1, 2.0, 3, 4.0],
    (1, 2.0, '3', "4"),
    [1, 2.0, '3', "4"],
)

    BioLab.print_header(an_)

    # @code_warntype BioLab.Array.error_duplicate(an_)

    # 127.152 ns (4 allocations: 400 bytes)
    # 128.388 ns (4 allocations: 400 bytes)
    # 97.690 ns (4 allocations: 400 bytes)
    # 97.602 ns (4 allocations: 400 bytes)
    # 407.500 ns (14 allocations: 688 bytes)
    # 126.114 ns (4 allocations: 400 bytes)
    # 333.900 ns (8 allocations: 544 bytes)
    # 265.244 ns (5 allocations: 416 bytes)
    # @btime BioLab.Array.error_duplicate($an_)

end

# TODO: Add to Julia.pro.
# Using `Set` in the function is faster and allocates less than using `unique`.
# `Vector` works faster with `Set.
# Heterogeneous collections are slow.
