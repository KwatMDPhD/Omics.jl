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

    @test Nucleus.Distance.get_distance(nu___, fu) == re

    # 23.343 ns (1 allocation: 96 bytes)
    # 43.096 ns (1 allocation: 96 bytes)
    # 53.150 ns (1 allocation: 128 bytes)
    # 53.203 ns (1 allocation: 128 bytes)
    # 43.517 ns (1 allocation: 96 bytes)
    #@btime Nucleus.Distance.get_distance($nu___, $fu)

end

# ---- #

for (nu___, re) in (
    (([1, 1], [1, 1]), []),
    (([1, 1], [2, 2]), []),
    (([1, 2], [1, 2]), []),
    (([1, 2, 3], [1, 2, 3]), []),
    (([1, 2, 3, 4], [1, 2, 3, 4]), []),
)

    fu = Nucleus.Information.get_information_coefficient_distance

    @info Nucleus.Distance.get_distance(nu___, fu)

    # 23.343 ns (1 allocation: 96 bytes)
    # 43.096 ns (1 allocation: 96 bytes)
    # 53.150 ns (1 allocation: 128 bytes)
    # 53.203 ns (1 allocation: 128 bytes)
    # 43.517 ns (1 allocation: 96 bytes)
    #@btime Nucleus.Distance.get_distance($nu___, $fu)

end
