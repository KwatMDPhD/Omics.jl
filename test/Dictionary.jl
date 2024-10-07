using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using OrderedCollections: OrderedDict

# ---- #

const DA = pkgdir(Omics, "data", "Dictionary")

const JS = joinpath(DA, "example.json")

for (fi, re) in (
    (JS, OrderedDict{String, Any}("fruit" => "Apple", "size" => "Large", "color" => "Red")),
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

    ke_va = Omics.Dictionary.rea(fi)

    @test typeof(ke_va) === typeof(re)

    @test ke_va == re

end

@test typeof(Omics.Dictionary.rea(JS, OrderedDict{String, String})) ===
      OrderedDict{String, String}

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

@test KE_VA ==
      Omics.Dictionary.rea(Omics.Dictionary.writ(joinpath(tempdir(), "write.json"), KE_VA))
