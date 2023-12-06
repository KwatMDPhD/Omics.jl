using Test: @test

using Nucleus

# ---- #

using Distances: SqEuclidean

# ---- #

for (nu___, re) in (
    (
        ([1], [1]),
        [
            0 0
            0 0
        ],
    ),
    (
        ([1], [2]),
        [
            0 1
            1 0
        ],
    ),
    (
        ([1], [2], [4]),
        [
            0 1 9
            1 0 4
            9 4 0
        ],
    ),
    (
        ([1], [4], [2]),
        [
            0 9 1
            9 0 4
            1 4 0
        ],
    ),
    (
        ([1, 2], [2, 1]),
        [
            0 2
            2 0
        ],
    ),
)

    fu = SqEuclidean()

    @test Nucleus.Distance.get(fu, nu___) == re

    # 23.343 ns (1 allocation: 96 bytes)
    # 25.728 ns (1 allocation: 96 bytes)
    # 23.301 ns (1 allocation: 96 bytes)
    # 25.770 ns (1 allocation: 96 bytes)
    # 34.575 ns (1 allocation: 128 bytes)
    # 30.820 ns (1 allocation: 128 bytes)
    # 34.491 ns (1 allocation: 128 bytes)
    # 30.810 ns (1 allocation: 128 bytes)
    # 23.385 ns (1 allocation: 96 bytes)
    # 26.272 ns (1 allocation: 96 bytes)

    #@btime Nucleus.Distance.get($fu, $nu___)

    #@btime Nucleus.Distance.get_half($fu, $nu___)

end

# ---- #

for ge in (Nucleus.Distance.get, Nucleus.Distance.get_half)

    nu___ = rand(100), rand(100)

    di = ge(Nucleus.Information.get_information_coefficient_distance, nu___)

    @info di == permutedims(di)

    # 64.292 μs (104 allocations: 108.70 KiB)
    # 31.583 μs (48 allocations: 54.27 KiB)
    #@btime $ge(Nucleus.Information.get_information_coefficient_distance, $nu___) 

end
