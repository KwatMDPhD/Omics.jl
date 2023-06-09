using OrderedCollections

include("environment.jl")

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
      BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))

@test BioLab.Dict.merge(ke2_va2, ke1_va1, BioLab.Dict.set_with_last!) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))

@test BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!) ==
      BioLab.Dict.merge(ke2_va2, ke1_va1, BioLab.Dict.set_with_first!)

# ---- #

da = joinpath(DA, "Dict")

# ---- #

js1 = joinpath(da, "example_1.json")

@test BioLab.Dict.read(js1) ==
      Dict{String, Any}("fruit" => "Apple", "color" => "Red", "size" => "Large")

# ---- #

js2 = joinpath(da, "example_2.json")

@test BioLab.Dict.read(js2) == Dict{String, Any}(
    "quiz" => Dict{String, Any}(
        "sport" => Dict{String, Any}(
            "q1" => Dict{String, Any}(
                "options" => Any[
                    "New York Bulls",
                    "Los Angeles Kings",
                    "Golden State Warriros",
                    "Huston Rocket",
                ],
                "question" => "Which one is correct team name in NBA?",
                "answer" => "Huston Rocket",
            ),
        ),
        "maths" => Dict{String, Any}(
            "q1" => Dict{String, Any}(
                "options" => Any["10", "11", "12", "13"],
                "question" => "5 + 7 = ?",
                "answer" => "12",
            ),
            "q2" => Dict{String, Any}(
                "options" => Any["1", "2", "3", "4"],
                "question" => "12 - 8 = ?",
                "answer" => "4",
            ),
        ),
    ),
)

# ---- #

to = joinpath(da, "example.toml")

@test BioLab.Dict.read(to) == Dict{String, Any}(
    "servers" => Dict{String, Any}(
        "alpha" => Dict{String, Any}("dc" => "eqdc10", "ip" => "10.0.0.1"),
        "beta" => Dict{String, Any}("dc" => "eqdc10", "ip" => "10.0.0.2"),
    ),
    "clients" => Dict{String, Any}(
        "hosts" => ["alpha", "omega"],
        "data" => Union{Vector{Int64}, Vector{String}}[["gamma", "delta"], [1, 2]],
    ),
    "owner" => Dict{String, Any}("name" => "Tom Preston-Werner"),
    "title" => "TOML Example",
    "database" => Dict{String, Any}(
        "server" => "192.168.1.1",
        "connection_max" => 5000,
        "ports" => [8000, 8001, 8002],
        "enabled" => true,
    ),
)

# ---- #

reduce(BioLab.Dict.merge, (BioLab.Dict.read(fi) for fi in (js1, js2, to)))

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

js = joinpath(mkpath(joinpath(tempdir(), "BioLab.test.Dict")), "write.json")

# ---- #

BioLab.Dict.write(js, ke_va)

@test ke_va == BioLab.Dict.read(js)

# ---- #

ke_va["Black Beard"] = ("Yami Yami", "Gura Gura")

BioLab.Dict.write(js, ke_va)

@test ke_va != BioLab.Dict.read(js)
