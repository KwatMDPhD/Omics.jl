using Test: @test

using Nucleus

# ---- #

const NU_ = (0, -0.000, 0.000, pi)

# ---- #

for (nu, re) in zip(NU_, ("0", "-0", "0", "3.1"))

    @test Nucleus.Number.format2(nu) === re

end

# ---- #

for (nu, re) in zip(NU_, ("0", "-0", "0", "3.142"))

    @test Nucleus.Number.format4(nu) === re

end

# ---- #

for ne in (-1.0, -1, -0.0)

    @test Nucleus.Number.is_negative(ne)

    # 1.458 ns (0 allocations: 0 bytes)
    # 1.458 ns (0 allocations: 0 bytes)
    # 1.459 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Number.is_negative($ne)

end

# ---- #

for po in (2.0, 2, 1.0, 1, 0.0, 0)

    @test !Nucleus.Number.is_negative(po)

end

# ---- #

for (nu_, re) in (([-1, 0, 1], [1, 2, 3]), ([0, 1, 2], [1, 2, 3]), ([0, 1, 2], [1, 2, 3]))

    @test Nucleus.Number.shift!(nu_) == re

    @test Nucleus.Number.shift!(nu_, 2) == re .+ 1

    # 7.667 ns (0 allocations: 0 bytes)
    # 7.041 ns (0 allocations: 0 bytes)
    # 7.083 ns (0 allocations: 0 bytes)
    #@btime Nucleus.Number.shift!($nu_)

end

# ---- #

for (nu_, re) in (([-2, 2, -1, 1, -0.0, 0], ([-2.0, -1.0, -0.0], [2.0, 1.0, 0.0])),)

    @test Nucleus.Number.separate(nu_) == re

    # 88.074 ns (4 allocations: 288 bytes)
    #@btime Nucleus.Number.separate($nu_)

end

# ---- #

for (an_, re) in (
    ([-1, 1, 2, 0], [-1, 1, 2, 0]),
    (['a', 'b', 'c', 'd'], [1, 2, 3, 4]),
    (['a', 'c', 'd', 'b'], [1, 2, 3, 4]),
)

    @test Nucleus.Number.ready(an_) == re

    # 1.500 ns (0 allocations: 0 bytes)
    # 316.386 ns (11 allocations: 1.00 KiB)
    # 318.961 ns (11 allocations: 1.00 KiB)
    #@btime Nucleus.Number.ready($an_)

end
