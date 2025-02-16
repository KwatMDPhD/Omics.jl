using Test: @test

using Omics

# ---- #

for (nu_, re) in (([1, 2, 3], [1, 2, 3]), ([1, 2, 3.0], [-1, 0, 1.0]))

    co = copy(nu_)

    Omics.Normalization.do_0_clamp!(co, 3.0)

    @test co == re

end

# ---- #

for (fl_, re) in (
    ([-1, 2, 3.0], [0, 0.5, 1]),
    ([-1, -1, 2, 3.0], [0, 0, 0.6000000000000001, 1]),
    ([-1, 2, 2, 3.0], [0, 0.5, 0.5, 1]),
    ([-1, 2, 3, 3.0], [0, 0.4, 1, 1]),
)

    co = copy(fl_)

    Omics.Normalization.do_125254_01!(co)

    @test co == re

end
