using OrderedCollections

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

for (an_, re) in (
    ((1, 2, 2, 3, 3, 3, 4), sort(Dict(1 => 1, 2 => 2, 3 => 3, 4 => 1))),
    (('a', 'b', 'b', 'c', 'c', 'c', 'd'), sort(Dict('a' => 1, 'b' => 2, 'c' => 3, 'd' => 1))),
)

    @test BioLab.Collection.count_sort(an_) == re

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

@test BioLab.Collection.is_in(BioLab.CA_, an1_) ==
      BioLab.Collection.is_in(BioLab.CA_, Set(an1_)) ==
      BioLab.Collection.is_in(Dict(ca => id for (id, ca) in enumerate(BioLab.CA_)), an1_)

# ---- #

di = joinpath(DA, "FeatureSetEnrichment")

da = BioLab.Table.read(joinpath(di, "gene_x_statistic_x_number.tsv"))

fe_ = reverse!(da[!, 1])

fe1_ = BioLab.GMT.read(joinpath(di, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

# ---- #

# 454.167 μs (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($fe_, $(Set(fe1_)));

# ---- #

# 740.875 μs (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($fe_, $fe1_);

# ---- #

# 616.616 ns (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($(Dict(fe => id for (id, fe) in enumerate(fe_))), $fe1_);

# ---- #

@test BioLab.Collection.index(("Aa", "Ii", "Uu", "Ee", "Oo")) == (
    Dict("Aa" => 1, "Ii" => 2, "Uu" => 3, "Ee" => 4, "Oo" => 5),
    Dict(1 => "Aa", 2 => "Ii", 3 => "Uu", 4 => "Ee", 5 => "Oo"),
)

# ---- #

for (ar_, re) in (
    ((1, 2), Int),
    ((1.0, 2.0), Float64),
    ((1, 2.0), Float64),
    (('a', 'b'), Char),
    (("Aa", "Bb"), String),
    (('a', "Aa"), Any),
    (([], []), Any),
    ((Int[], []), Any),
    ((Float64[], []), Any),
    ((Int[], Float64[]), Float64),
)

    @test BioLab.Collection.get_type(ar_) == re

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

@test BioLab.Collection.sort_recursively(
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
) == OrderedDict(
    "1ve" => [1, 2, 3],
    "2tu" => (2, 3, 1),
    "3di" => OrderedDict(),
    "4di" => OrderedDict("a" => 3, "b" => 2, "c" => 1),
    "5veh" => [1, "a"],
    "6vehd" => [1, 2, 3, OrderedDict("d1" => 1, "d2" => 2)],
    "7tuhd" => (2, 3, 1, Dict("d1" => 1, "d2" => 2)),
    "8ved" => [OrderedDict("e1" => 3, "e2" => 4), OrderedDict("e1" => 5, "e2" => 6)],
)
