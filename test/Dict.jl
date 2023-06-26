include("environment.jl")

# ---- #

DA = joinpath(BioLab.DA, "Dict")

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

@test BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!) ==
      BioLab.Dict.merge(ke1_va1, ke2_va2)

# ---- #

an1_an2 = Dict("A" => "A", "a" => "A", "b" => "B")

an1_ = ("A", "a", "b", "c")

an2_ = ["A", "A", "B", "c"]

ma_ = [1, 2, 2, 3]

@test BioLab.Dict.map(an1_an2, an1_) == (an2_, ma_)

@test BioLab.Dict.map(an1_an2, reverse(an1_)) == (reverse(an2_), reverse(ma_))

# ---- #

@test BioLab.Dict.read(joinpath(DA, "example_1.json")) ==
      Dict{String, Any}("fruit" => "Apple", "color" => "Red", "size" => "Large")

# ---- #

@test BioLab.Dict.read(joinpath(DA, "example_2.json")) == Dict{String, Any}(
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

@test BioLab.Dict.read(joinpath(DA, "example.toml")) == Dict{String, Any}(
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

js = joinpath(mkpath(joinpath(tempdir(), "BioLab.test.Dict")), "write_read.json")

# ---- #

BioLab.Dict.write(js, ke_va)

@test ke_va == BioLab.Dict.read(js)

# ---- #

ke_va["Black Beard"] = ("Yami Yami", "Gura Gura")

BioLab.Dict.write(js, ke_va)

@test ke_va != BioLab.Dict.read(js)
