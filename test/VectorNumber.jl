include("_.jl")

for (nu_, re) in (([-1, 0, 1, 2], 0.5), ([-2, -1, 0, 0, 1, 2], 0.0))

    BioLab.print_header(nu_)

    @test BioLab.VectorNumber.get_area(nu_) == re

    # @code_warntype BioLab.VectorNumber.get_area(nu_)

    # 4.000 ns (0 allocations: 0 bytes) 
    # 5.833 ns (0 allocations: 0 bytes)
    # @btime BioLab.VectorNumber.get_area($nu_)

end

nu_ = [-1, 0, 0, 1, 2]

for (nu_, re) in ((nu_, (2,)), (vcat(-maximum(nu_), nu_), (-2, 2)))

    BioLab.print_header(nu_)

    @test BioLab.VectorNumber.get_extreme(nu_) == re

    # @code_warntype BioLab.VectorNumber.get_extreme(nu_)

    # 6.125 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # @btime BioLab.VectorNumber.get_extreme($nu_)

end

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

    BioLab.print_header(nu)

    @test BioLab.VectorNumber.shift_minimum(nu_, nu) == re

    # @code_warntype BioLab.VectorNumber.shift_minimum(nu_, nu)

    # 25.573 ns (1 allocation: 112 bytes)
    # 25.573 ns (1 allocation: 112 bytes)
    # 25.699 ns (1 allocation: 112 bytes)
    # 25.448 ns (1 allocation: 112 bytes)
    # 25.699 ns (1 allocation: 112 bytes)
    # 25.616 ns (1 allocation: 112 bytes)
    # 25.658 ns (1 allocation: 112 bytes)
    # 173.267 ns (5 allocations: 528 bytes)
    # @btime BioLab.VectorNumber.shift_minimum($nu_, $nu)

end

for (nu_, re) in (
    ([0, 1, 2], [0, 1, 2]),
    ([0, 1, 2, 0], [0, 0, 0, 0]),
    ([0, 1, 2, 2, 1, 0, 1, 2, 3], [0, 0, 0, 0, 0, 0, 1, 2, 3]),
)

    BioLab.print_header(nu_)

    co_ = copy(nu_)

    BioLab.VectorNumber.force_increasing_with_min!(co_)

    println(co_)
    @test co_ == re

    co_ = copy(nu_)

    # @code_warntype BioLab.VectorNumber.force_increasing_with_min!(co_)

    # 8.008 ns (0 allocations: 0 bytes)
    # 9.217 ns (0 allocations: 0 bytes)
    # 14.487 ns (0 allocations: 0 bytes) 
    # @btime BioLab.VectorNumber.force_increasing_with_min!($co_) setup = (co_ = copy($nu_))

end

for (nu_, re) in (
    ([0, 1, 2], [0, 1, 2]),
    ([0, 1, 2, 0], [0, 1, 2, 2]),
    ([0, 1, 2, 2, 1, 0, 1, 2, 3], [0, 1, 2, 2, 2, 2, 2, 2, 3]),
)

    BioLab.print_header(nu_)

    co_ = copy(nu_)

    BioLab.VectorNumber.force_increasing_with_max!(co_)

    println(co_)
    @test co_ == re

    co_ = copy(nu_)

    # @code_warntype BioLab.VectorNumber.force_increasing_with_max!(co_)

    # 4.583 ns (0 allocations: 0 bytes)
    # 5.500 ns (0 allocations: 0 bytes)
    # 7.674 ns (0 allocations: 0 bytes) 
    # @btime BioLab.VectorNumber.force_increasing_with_max!($co_) setup = (co_ = copy($nu_))

end

nu_ = [1, NaN, 2, NaN, 3, NaN]

re = [11.0, NaN, 12.0, NaN, 13.0, NaN]

BioLab.print_header("!!")

function fu!(nu_)

    for id in eachindex(nu_)

        nu_[id] += 10

    end

    return nothing

end

co_ = copy(nu_)

BioLab.VectorNumber.skip_nan_and_apply!!(fu!, co_)

println(co_)

@test isequal(co_, re)

co_ = copy(nu_)

# @code_warntype BioLab.VectorNumber.skip_nan_and_apply!!(fu!, co_)

# 64.479 ns (2 allocations: 144 bytes)
# @btime BioLab.VectorNumber.skip_nan_and_apply!!($fu!, $co_) setup = (co_ = copy($nu_))

BioLab.print_header("!")

function fu(nu_)

    [nu + 10 for nu in nu_]

end

co_ = copy(nu_)

BioLab.VectorNumber.skip_nan_and_apply!(fu, co_)

println(co_)

@test isequal(co_, re)

co_ = copy(nu_)

# @code_warntype BioLab.VectorNumber.skip_nan_and_apply!(fu, co_)

# 92.714 ns (3 allocations: 224 bytes)
# @btime BioLab.VectorNumber.skip_nan_and_apply!($fu, $co_) setup = (co_ = copy($nu_))

n = 2

for di in ("Normal",)

    for ho in ("", "deep", "long")

        for ev in (false, true)

            BioLab.print_header("$di $ho $ev")

            # TODO: `@test`.
            display(BioLab.VectorNumber.simulate(n; di, ho, ev))

            # @code_warntype BioLab.VectorNumber.simulate(n; di, ho, ev)

            # 559.011 ns (13 allocations: 944 bytes)
            # 539.021 ns (12 allocations: 896 bytes)
            # 587.267 ns (14 allocations: 1.00 KiB)
            # 560.589 ns (13 allocations: 976 bytes)
            # 586.827 ns (14 allocations: 1.03 KiB)
            # 562.043 ns (13 allocations: 976 bytes)
            # @btime BioLab.VectorNumber.simulate($n; di = $di, ho = $ho, ev = $ev)

        end

    end

end
