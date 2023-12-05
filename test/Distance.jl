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

    @test Nucleus.Distance.get_distance(fu, nu___) == re

    # 23.301 ns (1 allocation: 96 bytes)
    # 23.320 ns (1 allocation: 96 bytes)
    # 34.533 ns (1 allocation: 128 bytes)
    # 34.533 ns (1 allocation: 128 bytes)
    # 23.469 ns (1 allocation: 96 bytes)
    #@btime Nucleus.Distance.get_distance($fu, $nu___)

end
