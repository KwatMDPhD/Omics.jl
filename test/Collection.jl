include("_.jl")

for an_ in ([], [20, 40, 60, 50, 30, 10], collect("bdfhjlnprtvxzywusqomkigeca"))

    BioLab.print_header()

    for n_ex in (0, 1, 2, length(an_) + 1)

        BioLab.print_header(n_ex)

        # TODO: `@test`.
        println(an_[BioLab.Collection.get_extreme_id(an_, n_ex)])

        # @code_warntype BioLab.Collection.get_extreme_id(an_, n_ex)

        # 19.266 ns (1 allocation: 64 bytes)
        # 19.289 ns (1 allocation: 64 bytes)
        # 19.225 ns (1 allocation: 64 bytes)
        # 19.267 ns (1 allocation: 64 bytes)
        # 19.266 ns (1 allocation: 64 bytes)
        # 328.168 ns (12 allocations: 960 bytes)
        # 349.958 ns (12 allocations: 1.00 KiB)
        # 390.881 ns (12 allocations: 1.14 KiB)
        # 19.308 ns (1 allocation: 64 bytes)
        # 495.923 ns (12 allocations: 1.09 KiB)
        # 524.215 ns (12 allocations: 1.16 KiB)
        # 945.800 ns (16 allocations: 3.16 KiB)
        # @btime BioLab.Collection.get_extreme_id($an_, $n_ex)

    end

end

an_ = BioLab.CA_

an1_ = ['1', '2', 'K']

@test BioLab.Collection.is_in(an_, an1_) ==
      [false, true, false, false, false, false, false, false, false, false, false, false, true]

an_id = Dict('A' => 1, '2' => 2, '3' => 3, 'Q' => 4, 'K' => 5)

@test BioLab.Collection.is_in(an_id, an1_) == [false, true, false, false, true]

fe_, sc_, fe1_ = BioLab.FeatureSetEnrichment.benchmark_myc()

BioLab.print_header("Set")

fe1s_ = Set(fe1_)

# @code_warntype BioLab.Collection.is_in(fe_, fe1s_)

# 499.417 μs (2 allocations: 19.67 KiB)
# 520.208 μs (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($fe_, $fe1s_)

BioLab.print_header("Vector")

# @code_warntype BioLab.Collection.is_in(fe_, fe1_)

# 743.583 μs (2 allocations: 19.67 KiB)
# 1.192 ms (2 allocations: 19.67 KiB)
# @btime BioLab.Collection.is_in($fe_, $fe1_)

BioLab.print_header("Dict")

fe_id = Dict(fe => id for (id, fe) in enumerate(fe_))

# @code_warntype BioLab.Collection.is_in(fe_id, fe1_)

# 1.367 μs (2 allocations: 19.67 KiB) 
# @btime BioLab.Collection.is_in($fe_id, $fe1_)

an_ = ("Aa", "Ii", "Uu", "Ee", "Oo")

@test BioLab.Collection.pair_index(an_) == (
    Dict("Aa" => 1, "Ii" => 2, "Uu" => 3, "Ee" => 4, "Oo" => 5),
    Dict(1 => "Aa", 2 => "Ii", 3 => "Uu", 4 => "Ee", 5 => "Oo"),
)

# @code_warntype BioLab.Collection.pair_index(an_)

# 197.218 ns (8 allocations: 1.03 KiB)
# @btime BioLab.Collection.pair_index($an_)

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

    BioLab.print_header(an_)

    @test BioLab.Collection.get_common_start(an_) == re

    # @code_warntype BioLab.Collection.get_common_start(an_)

    # 279.445 ns (5 allocations: 192 bytes)
    # 130.407 ns (4 allocations: 192 bytes)
    # 1.179 μs (17 allocations: 544 bytes)
    # 1.158 μs (20 allocations: 592 bytes)
    # 1.221 μs (17 allocations: 496 bytes)
    # 1.183 μs (17 allocations: 512 bytes)
    # 1.833 μs (19 allocations: 800 bytes)
    # 1.550 μs (13 allocations: 488 bytes)
    # @btime BioLab.Collection.get_common_start($an_)

end

ve1 = ['a', 'e', 'K', 't']

ve2 = ["a", "K", "t", "w"]

@test BioLab.Collection.sort_like(([2, 4, 1, 3], ve1, ve2)) ==
      [[1, 2, 3, 4], ['K', 'a', 't', 'e'], ["t", "a", "w", "K"]]

@test BioLab.Collection.sort_like(([3, 1, 4, 2], ve1, ve2)) ==
      [[1, 2, 3, 4], ['e', 't', 'a', 'K'], ["K", "w", "a", "t"]]

an__ = ([1, 3, 5, 6, 4, 2], "acefdb")

@test BioLab.Collection.sort_like(an__) == [[1, 2, 3, 4, 5, 6], "abcdef"]

@test BioLab.Collection.sort_like(an__; ic = false) == [[6, 5, 4, 3, 2, 1], "fedcba"]

# @code_warntype BioLab.Collection.sort_like(an__)

# 408.955 ns (9 allocations: 552 bytes)
# @btime BioLab.Collection.sort_like($an__)

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

    BioLab.print_header(ar_)

    @test BioLab.Collection.get_type(ar_...) == re

    # @code_warntype BioLab.Collection.get_type(ar_...)

    # 17.200 ns (1 allocation: 80 bytes)
    # 17.452 ns (1 allocation: 80 bytes)
    # 107.162 ns (4 allocations: 160 bytes)
    # 16.825 ns (1 allocation: 64 bytes)
    # 18.036 ns (1 allocation: 64 bytes)
    # 45.283 ns (1 allocation: 64 bytes)
    # 45.539 ns (1 allocation: 48 bytes)
    # 44.021 ns (1 allocation: 48 bytes)
    # 45.753 ns (1 allocation: 48 bytes)
    # 45.374 ns (1 allocation: 64 bytes)
    # @btime BioLab.Collection.get_type($ar_...)

end

an = Dict(
    "8ved" => [Dict("e2" => 4, "e1" => 3), Dict("e2" => 6, "e1" => 5)],
    "7tuhd" => (2, 3, 1, Dict("d2" => 2, "d1" => 1)),
    "6vehd" => [2, 3, 1, Dict("d2" => 2, "d1" => 1)],
    "5veh" => [1, "a"],
    "4di" => Dict("c" => 1, "b" => 2, "a" => 3),
    "3di" => Dict(),
    "2tu" => (2, 3, 1),
    "1ve" => [2, 3, 1],
)

# TODO: `@test`.
BioLab.Dict.print(BioLab.Collection.sort_recursively(an))

# @code_warntype BioLab.Collection.sort_recursively(an)

# 7.284 ms (224 allocations: 14.72 KiB)
# @btime BioLab.Collection.sort_recursively($an)
