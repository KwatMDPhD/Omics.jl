using Test: @test

using Omics

# ---- #

for (nu_, um, re) in (([-1, 1], 2, -1.0:2:1), ([1, -1], 3, -1.0:1))

    @test Omics.Grid.make(nu_, um) === re

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

end
