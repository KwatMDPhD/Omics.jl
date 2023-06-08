include("environment.jl")

# ---- #

for an_ in (
    (1, 1),
    [1, 1],
    [1, 2, 2],
    [1 1; 2 2],
    [1 2; 1 2],
    [1 2; 3 1],
    [nothing, nothing],
    [missing, missing],
    [NaN, NaN],
    [Inf, Inf],
    [0.5, 1 / 2, 1 // 2],
    ['a', 'b', 'b'],
)

    @test @is_error BioLab.Collection.error_duplicate(an_)

end

# ---- #

for an_ in (
    (),
    (1, 2),
    [],
    [1, 2],
    [1, 2, 3],
    [1 2; 3 4],
    [nothing, missing, NaN, -Inf, Inf, -0.0, 0.0],
    [1.0, 2],
    ['a', 'b', 'c'],
    ['a', 'b', 'c', "c"],
)

    BioLab.Collection.error_duplicate(an_)

end

# ---- #

for an_ in (
    (1, 1),
    [1, 1],
    [1, 1, 1],
    [1 1],
    [1 1; 1 1],
    [nothing, nothing],
    [missing, missing],
    [NaN, NaN],
    [-Inf, -Inf],
    [Inf, Inf],
    ['a', 'a'],
    ["a", "a"],
)

    @test @is_error BioLab.Collection.error_no_change(an_)

end

# ---- #

for an_ in (
    (),
    (1, 2),
    [],
    [1, 2],
    [1, 2, 3],
    [1 2],
    [1 1; 1 2],
    [1.0, 2],
    [nothing, missing],
    [nothing, NaN],
    [missing, NaN],
    [-Inf, Inf],
    [-0.0, 0.0],
    ['a', 'b'],
    ['a', "a"],
)

    BioLab.Collection.error_no_change(an_)

end


# ---- #

for (n, n_ex) in ((0, 0), (0, 1), (1, 0))

    @test BioLab.Collection.get_extreme(n, n_ex) == Vector{Int}()

end

# ---- #

for (n, n_ex, re) in ((5, 1, [1, 5]), (5, 3, [1, 2, 3, 4, 5]), (5, 6, [1, 2, 3, 4, 5]))

    @test BioLab.Collection.get_extreme(n, n_ex) == re

end

# ---- #

co1 = []

co2 = [20, 40, 60, 50, 30, 10]

co3 = collect("bdfhjlnprtvxzywusqomkigeca")

for (an_, n_ex, re) in (
    (co1, 0, co1),
    (co1, 1, co1),
    (co2, 0, Vector{Int}()),
    (co2, 1, [10, 60]),
    (co2, 2, [10, 20, 50, 60]),
    (co2, length(co2) + 1, sort(co2)),
    (co3, 0, Vector{Char}()),
    (co3, 1, ['a', 'z']),
    (co3, 2, ['a', 'b', 'y', 'z']),
    (co3, length(co3) + 1, sort(co3)),
)

    @test an_[BioLab.Collection.get_extreme(an_, n_ex)] == re

end

# ---- #

an1_ = ['1', '2', 'K']

@test BioLab.Collection.is_in(BioLab.CA_, an1_) ==
      [false, true, false, false, false, false, false, false, false, false, false, false, true]

@test BioLab.Collection.is_in(Dict('A' => 1, '2' => 2, '3' => 3, 'Q' => 4, 'K' => 5), an1_) ==
      [false, true, false, false, true]

@test BioLab.Collection.is_in(Dict('A' => 5, '2' => 4, '3' => 3, 'Q' => 2, 'K' => 1), an1_) ==
      [true, false, false, true, false]

# ---- #

di = joinpath(DA, "FeatureSetEnrichment")

da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

fe_ = reverse!(da[!, 1])

sc_ = reverse!(da[!, 2])

fe1_ = BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

# ---- #

# 462.167 μs (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($fe_, $(Set(fe1_)));

# ---- #

# 743.000 μs (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($fe_, $fe1_);

# ---- #

# 620.066 ns (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($(Dict(fe => id for (id, fe) in enumerate(fe_))), $fe1_);

# ---- #

an_ = ("Aa", "Ii", "Uu", "Ee", "Oo")

@test BioLab.Collection.index(an_) == (
    Dict("Aa" => 1, "Ii" => 2, "Uu" => 3, "Ee" => 4, "Oo" => 5),
    Dict(1 => "Aa", 2 => "Ii", 3 => "Uu", 4 => "Ee", 5 => "Oo"),
)

# ---- #

for (an_, re) in (
    (((), ()), ()),
    ((Vector{Int}(), Vector{Int}()), Vector{Int}()),
    (((1,), (1, 2)), (1,)),
    (((1.0,), (1.0, 2.0)), (1.0,)),
    ((('a', 'b'), ('a',)), ('a',)),
    ((("a", "b"), ("a",)), ("a",)),
    (((1, 2, 3), (1, 4, 5)), (1,)),
    (("aiueo", "aiue", "aiu"), "aiu"),
)

    @test BioLab.Collection.get_common_start(an_) == re

end

# ---- #

ve1 = ['a', 'e', 'K', 't']

ve2 = ["a", "K", "t", "w"]

@test Tuple(BioLab.Collection.sort_like(([2, 4, 1, 3], ve1, ve2))) ==
      ([1, 2, 3, 4], ['K', 'a', 't', 'e'], ["t", "a", "w", "K"])

@test Tuple(BioLab.Collection.sort_like(([3, 1, 4, 2], ve1, ve2))) ==
      ([1, 2, 3, 4], ['e', 't', 'a', 'K'], ["K", "w", "a", "t"])

# ---- #

an___ = ([1, 3, 5, 6, 4, 2], "acefdb")

for (rev, re) in ((false, ([1, 2, 3, 4, 5, 6], "abcdef")), (true, ([6, 5, 4, 3, 2, 1], "fedcba")))

    @test Tuple(BioLab.Collection.sort_like(an___; rev)) == re

end

# ---- #

for (ar_, re) in (
    ((1, 2), Int),
    ((3.0, 4.0), Float64),
    ((5, 6.0), Float64),
    (('a', 'b'), Char),
    (("Cc", "Dd"), String),
    (('e', "Ff"), Any),
    (([], []), Any),
    ((Int[], []), Any),
    ((Float64[], []), Any),
    ((Float64[], Int[]), Float64),
)

    @test BioLab.Collection.get_type(ar_) == re

end

# ---- #

BioLab.Collection.sort_recursively(
    Dict(
        "8ved" => [Dict("e2" => 4, "e1" => 3), Dict("e2" => 6, "e1" => 5)],
        "7tuhd" => (2, 3, 1, Dict("d2" => 2, "d1" => 1)),
        "6vehd" => [2, 3, 1, Dict("d2" => 2, "d1" => 1)],
        "5veh" => [1, "a"],
        "4di" => Dict("c" => 1, "b" => 2, "a" => 3),
        "3di" => Dict(),
        "2tu" => (2, 3, 1),
        "1ve" => [2, 3, 1],
    ),
)
