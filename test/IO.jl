using LeMoIO

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using OrderedCollections: OrderedDict

# ---- #

const DA = pkgdir(LeMoIO, "data")

# ---- #

const WR = joinpath(tempdir(), "write")

# ---- #

const JS = joinpath(DA, "example_1.json")

# ---- #

@test typeof(LeMoIO.read_dictionary(JS)) === OrderedDict{String, Any}

# ---- #

@test typeof(LeMoIO.read_dictionary(JS, OrderedDict{String, String})) ===
      OrderedDict{String, String}

# ---- #

for (fi, re) in (
    (
        joinpath(DA, "example_2.json"),
        OrderedDict{String, Any}(
            "quiz" => Dict(
                "sport" => Dict(
                    "q1" => Dict(
                        "options" => [
                            "New York Bulls",
                            "Los Angeles Kings",
                            "Golden State Warriros",
                            "Huston Rocket",
                        ],
                        "question" => "Which one is correct team name in NBA?",
                        "answer" => "Huston Rocket",
                    ),
                ),
                "maths" => Dict(
                    "q1" => Dict(
                        "options" => ["10", "11", "12", "13"],
                        "question" => "5 + 7 = ?",
                        "answer" => "12",
                    ),
                    "q2" => Dict(
                        "options" => ["1", "2", "3", "4"],
                        "question" => "12 - 8 = ?",
                        "answer" => "4",
                    ),
                ),
            ),
        ),
    ),
    (
        joinpath(DA, "example.toml"),
        Dict{String, Any}(
            "servers" => Dict(
                "alpha" => Dict("dc" => "eqdc10", "ip" => "10.0.0.1"),
                "beta" => Dict("dc" => "eqdc10", "ip" => "10.0.0.2"),
            ),
            "clients" =>
                Dict("hosts" => ["alpha", "omega"], "data" => [["gamma", "delta"], [1, 2]]),
            "owner" => Dict("name" => "Tom Preston-Werner"),
            "title" => "TOML Example",
            "database" => Dict(
                "server" => "192.168.1.1",
                "connection_max" => 5000,
                "ports" => [8000, 8001, 8002],
                "enabled" => true,
            ),
        ),
    ),
)

    ke_va = LeMoIO.read_dictionary(fi)

    @test typeof(ke_va) === typeof(re)

    @test ke_va == re

end

# ---- #

const KE_VA = Dict(
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

# ---- #

@test KE_VA == LeMoIO.read_dictionary(LeMoIO.write_dictionary(WR, KE_VA))

# ---- #

const TI = LeMoIO.read_table(joinpath(DA, "titanic.tsv"))

# ---- #

@test all(map(isequal, eachcol(TI), eachcol(LeMoIO.read_table(LeMoIO.write_table(WR, TI)))))

# ---- #

const EN = LeMoIO.read_table(joinpath(DA, "enst_gene.tsv.gz"))

# ---- #

@test EN == LeMoIO.read_table(LeMoIO.write_table(WR, EN))

# ---- #

const XL = LeMoIO.read_table(
    joinpath(DA, "12859_2019_2886_MOESM2_ESM.xlsx"),
    "HumanSpecific Genes",
)

# ---- #

LeMoIO.read_table(LeMoIO.write_table(WR, XL))
