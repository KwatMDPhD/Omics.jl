using OrderedCollections

include("_.jl")

# ----------------------------------------------------------------------------------------------- #

for ty in (Dict, OrderedDict)

    BioLab.print_header(ty)

    BioLab.Dict.print(ty())

end

ke_va = Dict(1 => "a", 2 => "a", 3 => "b", '4' => nothing, "5" => nothing, 6 => NaN)

BioLab.Dict.print(ke_va)

for n in 1:6

    BioLab.print_header(n)

    BioLab.Dict.print(ke_va; n)

end

for ke_va in (Dict('a' => 1), Dict('a' => 1, "a" => 2), Dict('a' => 1, "a" => 2, 3 => 2))

    BioLab.print_header(ke_va)

    BioLab.Dict.print(ke_va)

    # @code_warntype BioLab.Dict.print(ke_va)

end

# ----------------------------------------------------------------------------------------------- #

ke_va = Dict("k1" => "v1", "k2" => "v2", 3 => 4)

@test BioLab.Dict.symbolize(ke_va) == Dict(:k1 => "v1", :k2 => "v2", Symbol(3) => 4)

# @code_warntype BioLab.Dict.symbolize(ke_va)

# 1.188 μs (9 allocations: 696 bytes) 
# @btime BioLab.Dict.symbolize($ke_va)

# ----------------------------------------------------------------------------------------------- #

ke_va = Dict("Existing" => 1)

for (ke, va) in (("Existing", 1), ("Existing", 2), ("New", 3))

    BioLab.print_header("$ke ➡️ $va")

    co = copy(ke_va)

    BioLab.Dict.set_with_first!(co, ke, va)

    # TODO: `@test`.
    BioLab.Dict.print(co)

    # @code_warntype BioLab.Dict.set_with_first!(co, ke, va)

    # 44.063 ns (0 allocations: 0 bytes)
    # 43.979 ns (0 allocations: 0 bytes)
    # 29.983 ns (0 allocations: 0 bytes)
    # @btime BioLab.Dict.set_with_first!($co, $ke, $va; pr = $false) setup = (co = copy($ke_va))

end

# ----------------------------------------------------------------------------------------------- #

for (ke, va) in (("Existing", 1), ("Existing", 2), ("New", 3))

    BioLab.print_header("$ke ➡️ $va")

    co = copy(ke_va)

    BioLab.Dict.set_with_last!(co, ke, va)

    # TODO: `@test`.
    BioLab.Dict.print(co)

    # @code_warntype BioLab.Dict.set_with_last!(co, ke, va)

    # 48.660 ns (0 allocations: 0 bytes)
    # 48.710 ns (0 allocations: 0 bytes)
    # 47.817 ns (0 allocations: 0 bytes)
    # @btime BioLab.Dict.set_with_last!($co, $ke, $va; pr = $false) setup = (co = copy($ke_va))

end

# ----------------------------------------------------------------------------------------------- #

for (ke, va) in (("Existing", 1), ("Existing", 2), ("New", 3))

    BioLab.print_header("$ke ➡️ $va")

    co = copy(ke_va)

    BioLab.Dict.set_with_suffix!(co, ke, va)

    # TODO: `@test`.
    BioLab.Dict.print(co)

    # @code_warntype BioLab.Dict.set_with_suffix!(co, ke, va)

    # 48.660 ns (0 allocations: 0 bytes)
    # 48.710 ns (0 allocations: 0 bytes)
    # 47.817 ns (0 allocations: 0 bytes)
    # @btime BioLab.Dict.set_with_suffix!($co, $ke, $va; pr = $false) setup = (co = copy($ke_va))

end

# ----------------------------------------------------------------------------------------------- #

ke1_va1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

ke2_va2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

@test BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))

@test BioLab.Dict.merge(ke2_va2, ke1_va1, BioLab.Dict.set_with_last!) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))

@test BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!) ==
      BioLab.Dict.merge(ke2_va2, ke1_va1, BioLab.Dict.set_with_first!)

# @code_warntype BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!)

# 1.658 μs (22 allocations: 2.03 KiB)
# @btime BioLab.Dict.merge($ke1_va1, $ke2_va2, $BioLab.Dict.set_with_last!; pr = $false)

# ----------------------------------------------------------------------------------------------- #

ke1_va1 = Dict("Aa" => 1, 'b' => 2)

ke2_va2 = Dict("Aa" => 3, 'b' => 2, 4 => 5)

BioLab.Dict.merge(ke1_va1, ke2_va2)

# @code_warntype BioLab.Dict.merge(ke1_va1, ke2_va2)

# ----------------------------------------------------------------------------------------------- #

da = joinpath(@__DIR__, "dict.data")

js1 = joinpath(da, "example_1.json")

js2 = joinpath(da, "example_2.json")

to = joinpath(da, "example.toml")

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read(js1))

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read(js2))

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read(to))

pa_ = (js1, js2, to)

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read(pa_))

# @code_warntype BioLab.Dict.read(pa_)

# ----------------------------------------------------------------------------------------------- #

ke_va = Dict(
    "Luffy" => "Pirate King",
    "Crews" => [
        "Luffy",
        "Zoro",
        "Nami",
        "Usopp",
        "Sanji",
        "Chopper",
        "Robin",
        "Franky",
        "Brook",
        "Jinbe",
    ],
    "episode" => 1030,
)

te = joinpath(tempdir(), "BioLab.test.Dict")

BioLab.Path.reset(te)

js = joinpath(te, "write.json")

BioLab.Dict.write(js, ke_va)

@test ke_va == BioLab.Dict.read(js)

ke_va["Black Beard"] = ("Yami Yami", "Gura Gura")

BioLab.Dict.print(ke_va)

BioLab.Dict.write(js, ke_va)

ke2_va2 = BioLab.Dict.read(js)

BioLab.Dict.print(ke2_va2)

@test ke_va != ke2_va2

# @code_warntype BioLab.Dict.write(js, ke_va)
