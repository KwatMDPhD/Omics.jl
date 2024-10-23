using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

# ---- #

for (nu_, ug, re) in (([-1, 1], 2, -1.0:2:1), ([1, -1], 3, -1.0:1:1))

    @test Omics.Grid.make(nu_, ug) === re

    # 50.016 ns (0 allocations: 0 bytes)
    # 49.992 ns (0 allocations: 0 bytes)
    #@btime Omics.Grid.make($nu_, $ug)

end

# ---- #

const GR_ = [-4, -2, -1, 0, 1, 2, 4]

for (nu, re) in (
    (-5, 1),
    (-4, 1),
    (-3, 2),
    (-2, 2),
    (-1, 3),
    (0, 4),
    (1, 5),
    (2, 6),
    (3, 7),
    (4, 7),
    (5, 7),
)

    @test Omics.Grid.find(GR_, nu) === re

    # 2.375 ns (0 allocations: 0 bytes)
    # 2.375 ns (0 allocations: 0 bytes)
    # 3.041 ns (0 allocations: 0 bytes)
    # 3.041 ns (0 allocations: 0 bytes)
    # 3.958 ns (0 allocations: 0 bytes)
    # 4.250 ns (0 allocations: 0 bytes)
    # 4.542 ns (0 allocations: 0 bytes)
    # 4.875 ns (0 allocations: 0 bytes)
    # 5.166 ns (0 allocations: 0 bytes)
    # 5.166 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    #@btime Omics.Grid.find(GR_, $nu)

end
