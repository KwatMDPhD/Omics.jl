using OrderedCollections

include("environment.jl")

# ---- #

for ty in (Dict, OrderedDict)

    BioLab.Dict.print(ty())

end

# ---- #

ke_va = Dict(1 => "a", 2 => "a", 3 => "b", '4' => nothing, "5" => nothing, 6 => NaN)

BioLab.Dict.print(ke_va)

# ---- #

for n in 1:6

    BioLab.Dict.print(ke_va; n)

end

# ---- #

for ke_va in (Dict('a' => 1), Dict('a' => 1, "a" => 2), Dict('a' => 1, "a" => 2, 3 => 2))

    BioLab.Dict.print(ke_va)

end

# ---- #

ke_va = Dict("Existing" => 1)

# ---- #

for (ke, va, re) in
    (("Existing", 1, ke_va), ("Existing", 2, ke_va), ("New", 3, Dict("Existing" => 1, "New" => 3)))

    co = copy(ke_va)

    BioLab.Dict.set_with_first!(co, ke, va)

    @test co == re

end

# ---- #

for (ke, va, re) in (
    ("Existing", 1, ke_va),
    ("Existing", 2, Dict("Existing" => 2)),
    ("New", 3, Dict("Existing" => 1, "New" => 3)),
)

    co = copy(ke_va)

    BioLab.Dict.set_with_last!(co, ke, va)

    @test co == re

end

# ---- #

for (ke, va, re) in (
    ("Existing", 1, Dict("Existing" => 1, "Existing.2" => 1)),
    ("Existing", 2, Dict("Existing" => 1, "Existing.2" => 2)),
    ("New", 3, Dict("Existing" => 1, "New" => 3)),
)

    co = copy(ke_va)

    BioLab.Dict.set_with_suffix!(co, ke, va)

    @test co == re

end

# ---- #

ke1_va1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

ke2_va2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

@test BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))

@test BioLab.Dict.merge(ke2_va2, ke1_va1, BioLab.Dict.set_with_last!) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))

@test BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!) ==
      BioLab.Dict.merge(ke2_va2, ke1_va1, BioLab.Dict.set_with_first!)

# ---- #

ke1_va1 = Dict("Aa" => 1, 'b' => 2)

ke2_va2 = Dict("Aa" => 3, 'b' => 2, 4 => 5)

@test BioLab.Dict.merge(ke1_va1, ke2_va2) == Dict("Aa" => 3, 'b' => 2, 4 => 5)

# ---- #

da = joinpath(pkgdir(BioLab), "data", "Dict")

# ---- #

js1 = joinpath(da, "example_1.json")

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read(js1))

# ---- #

js2 = joinpath(da, "example_2.json")

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read(js2))

# ---- #

to = joinpath(da, "example.toml")

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read(to))

# ---- #

# TODO: `@test`.
BioLab.Dict.print(BioLab.Dict.read((js1, js2, to)))

# ---- #

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

te = mkpath(joinpath(tempdir(), "BioLab.test.Dict"))

# ---- #

js = joinpath(te, "write.json")

BioLab.Dict.write(js, ke_va)

@test ke_va == BioLab.Dict.read(js)

# ---- #

ke_va["Black Beard"] = ("Yami Yami", "Gura Gura")

BioLab.Dict.write(js, ke_va)

@test ke_va != BioLab.Dict.read(js)
