using Random: seed!

using StatsBase: mean

using Test: @test

using BioLab

# ---- #

seed!(20230722)

# ---- #

const NU11_ = [0, 0, 1, 1]

const NU21_ = [2, 3, 4, 5]

const RE1 = ([2, 3], [4, 5])

for (nu1_, re) in ((NU11_, (NU11_, NU21_)), (Vector{Bool}(NU11_), RE1), (BitVector(NU11_), RE1))

    @test BioLab.Target._aim(nu1_, NU21_) == re

    # 1.459 ns (0 allocations: 0 bytes)
    # 86.672 ns (4 allocations: 256 bytes)
    # 75.996 ns (4 allocations: 256 bytes)
    #@btime BioLab.Target._aim($nu1_, $NU21_)

end

# ---- #

const NU11R_ = rand((0, 1), 1000)

const NU21R_ = randn(length(NU11R_))

for nu1_ in (randn(length(NU11R_)), Vector{Bool}(NU11R_), BitVector(NU11R_))

    # 1.458 ns (0 allocations: 0 bytes)
    # 1.525 μs (5 allocations: 12.53 KiB)
    # 1.262 μs (4 allocations: 8.34 KiB)
    #@btime BioLab.Target._aim($nu1_, $NU21R_)

end

# ---- #

function fus(nu1_, nu2_)

    sum(nu1_) - sum(nu2_)

end

# ---- #

const NU12_ = [0, 0, 1, 1]

const NU22_ = [1, 10, 100, 1000]

const RE2 = -1089

for (nu1_, re) in ((NU22_ .+ 1, 4), (Vector{Bool}(NU12_), RE2), (BitVector(NU12_), RE2))

    @test BioLab.Target._trigger(fus, nu1_, NU22_) == re

    # 3.958 ns (0 allocations: 0 bytes)
    # 89.438 ns (4 allocations: 256 bytes)
    # 78.814 ns (4 allocations: 256 bytes)
    #@btime BioLab.Target._trigger($fus, $nu1_, $NU22_)

end

# ---- #

const NU12R_ = rand((0, 1), 1000)

const NU22R_ = randn(length(NU12R_))

for nu1_ in (randn(length(NU12R_)), Vector{Bool}(NU12R_), BitVector(NU12R_))

    # 347.093 ns (0 allocations: 0 bytes)
    # 1.675 μs (5 allocations: 12.53 KiB)
    # 1.408 μs (4 allocations: 8.34 KiB)
    #@btime BioLab.Target._trigger($fus, $nu1_, $NU22R_)

end

# ---- #

function fum(nu1_, nu2_)

    mean(nu1_) - mean(nu2_)

end

# ---- #

const NU13_ = [0, 0, 0, 1, 1, 1]

const MA23 = BioLab.Simulation.make_matrix_123(2, 6)

const RE3 = [-6.0, -6]

for (nu1_, re) in (
    ([1, 10, 100, 1000, 10000, 100000], [18512.5, 18511.5]),
    (Vector{Bool}(NU13_), RE3),
    (BitVector(NU13_), RE3),
)

    @test BioLab.Target.target(fum, nu1_, MA23) == re

    # 42.718 ns (1 allocation: 80 bytes)
    # 215.223 ns (9 allocations: 592 bytes)
    # 184.788 ns (9 allocations: 592 bytes)
    #@btime BioLab.Target.target($fum, $nu1_, $MA23)

end

# ---- #

const NU13R_ = rand((0, 1), 1000)

const MA23R = randn((100, length(NU13R_)))

for nu1_ in (randn(length(NU13R_)), Vector{Bool}(NU13R_), BitVector(NU13R_))

    # 104.458 μs (1 allocation: 896 bytes)
    # 174.417 μs (501 allocations: 1.22 MiB)
    # 158.125 μs (401 allocations: 835.25 KiB)
    #@btime BioLab.Target.target($fum, $nu1_, $MA23R)

end
