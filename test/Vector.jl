using Test: @test

# ---- #

em = Vector{Int}()

for (n, n_ex, re) in (
    (0, 0, em),
    (0, 1, em),
    (1, 0, em),
    (5, 1, [1, 5]),
    (5, 3, [1, 2, 3, 4, 5]),
    (5, 6, [1, 2, 3, 4, 5]),
)

    @test BioLab.Vector.get_extreme(n, n_ex) == re

end

# ---- #

co2 = [20, 40, 60, 50, 30, 10]

co3 = collect("bdfhjlnprtvxzywusqomkigeca")

for (an_, n_ex, re) in (
    (em, 0, em),
    (em, 1, em),
    (co2, 0, Vector{Int}()),
    (co2, 1, [10, 60]),
    (co2, 2, [10, 20, 50, 60]),
    (co2, length(co2) + 1, sort(co2)),
    (co3, 0, Vector{Char}()),
    (co3, 1, ['a', 'z']),
    (co3, 2, ['a', 'b', 'y', 'z']),
    (co3, length(co3) + 1, sort(co3)),
)

    @test an_[BioLab.Vector.get_extreme(an_, n_ex)] == re

end

# ---- #

fl_ = [NaN, 1, NaN, 2, NaN, 3, NaN, 4, NaN, 5]

for (n, re) in ((1, [2, 10]), (2, [2, 4, 8, 10]), (3, [2, 4, 6, 8, 10]))

    @test BioLab.Vector.get_extreme(fl_, n) == re

end

# ---- #

ve1 = ['a', 'e', 'K', 't']

ve2 = ["a", "K", "t", "w"]

@test Tuple(BioLab.Vector.sort_like(([2, 4, 1, 3], ve1, ve2))) ==
      ([1, 2, 3, 4], ['K', 'a', 't', 'e'], ["t", "a", "w", "K"])

@test Tuple(BioLab.Vector.sort_like(([3, 1, 4, 2], ve1, ve2))) ==
      ([1, 2, 3, 4], ['e', 't', 'a', 'K'], ["K", "w", "a", "t"])

# ---- #

an___ = ([1, 3, 5, 6, 4, 2], "acefdb")

for (rev, re) in ((false, ([1, 2, 3, 4, 5, 6], "abcdef")), (true, ([6, 5, 4, 3, 2, 1], "fedcba")))

    @test Tuple(BioLab.Vector.sort_like(an___; rev)) == re

end

# ---- #

n = 1000

me_ = randn(n)

for (mi, ma, re) in
    ((0, 0, fill(false, n)), (-Inf, 0, me_ .<= 0), (0, Inf, 0 .<= me_), (-Inf, Inf, fill(true, n)))

    @test BioLab.Vector.select(TE, me_, mi, ma) == re

end
