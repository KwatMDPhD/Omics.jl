using Test: @test

using Nucleus

# ---- #

for ne in (-2.0, -2, -1.0, -1, -0.0)

    @test Nucleus.Number.is_negative(ne)

    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.458 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Number.is_negative($ne)

end

# ---- #

for po in (2.0, 2, 1.0, 1, 0.0, 0)

    @test Nucleus.Number.is_positive(po)

    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.458 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Number.is_positive($po)

end
