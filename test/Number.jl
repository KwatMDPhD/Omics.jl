using Test: @test

using BioLab

# ---- #

for nu in (-2.0, -2, -1.0, -1, -0.0)

    @test BioLab.Number.is_negative(nu)

    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    @btime BioLab.Number.is_negative($nu)

end

# ---- #

for nu in (2.0, 2, 1.0, 1, 0.0, 0)

    @test BioLab.Number.is_positive(nu)

    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    # 1.500 ns (0 allocations: 0 bytes)
    @btime BioLab.Number.is_positive($nu)

end
