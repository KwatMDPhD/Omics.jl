using Random

include("environment.jl")

# ---- #

for (nu_, re) in (([-1, 0, 1, 2], 0.5), ([-2, -1, 0, 0, 1, 2], 0.0))

    @test BioLab.VectorNumber.get_area(nu_) == re

end

# ---- #

nu_ = [-1, 0, 0, 1, 2]

for (nu_, re) in ((nu_, (2,)), (vcat(-maximum(nu_), nu_), (-2, 2)))

    @test BioLab.VectorNumber.get_extreme(nu_) == re

end

# ---- #

nu_ = collect(-3:3)

for (nu, re) in zip(
    vcat(nu_, "0<"),
    (
        [-3, -2, -1, 0, 1, 2, 3],
        [-2, -1, 0, 1, 2, 3, 4],
        [-1, 0, 1, 2, 3, 4, 5],
        [0, 1, 2, 3, 4, 5, 6],
        [1, 2, 3, 4, 5, 6, 7],
        [2, 3, 4, 5, 6, 7, 8],
        [3, 4, 5, 6, 7, 8, 9],
        [1, 2, 3, 4, 5, 6, 7],
    ),
)

    @test BioLab.VectorNumber.shift_minimum(nu_, nu) == re

end

# ---- #

for (nu_, re) in (
    ([0, 1, 2], [0, 1, 2]),
    ([0, 1, 2, 0], [0, 0, 0, 0]),
    ([0, 1, 2, 2, 1, 0, 1, 2, 3], [0, 0, 0, 0, 0, 0, 1, 2, 3]),
)

    BioLab.VectorNumber.force_increasing_with_min!(nu_)

    @test nu_ == re

end

# ---- #

for (nu_, re) in (
    ([0, 1, 2], [0, 1, 2]),
    ([0, 1, 2, 0], [0, 1, 2, 2]),
    ([0, 1, 2, 2, 1, 0, 1, 2, 3], [0, 1, 2, 2, 2, 2, 2, 2, 3]),
)

    BioLab.VectorNumber.force_increasing_with_max!(nu_)

    @test nu_ == re

end

# ---- #

nu_ = [1, NaN, 2, NaN, 3, NaN]

re = [11.0, NaN, 12.0, NaN, 13.0, NaN]

# ---- #

function fu!(nu_)

    nu_ .+= 10

end

co_ = copy(nu_)

BioLab.VectorNumber.skip_nan_apply!!(fu!, co_)

@test isequal(co_, re)

# ---- #

function fu(nu_)

    [nu + 10 for nu in nu_]

end

co_ = copy(nu_)

BioLab.VectorNumber.skip_nan_apply!(fu, co_)

@test isequal(co_, re)

# ---- #

n = 3

for ty in (BioLab.VectorNumber.Original, BioLab.VectorNumber.Deep, BioLab.VectorNumber.Wide)

    for ze in (false, true)

        Random.seed!(BioLab.Constant.RA)

        # TODO: `@test`.
        println(BioLab.VectorNumber.simulate(n, ty; ze))

    end

end
