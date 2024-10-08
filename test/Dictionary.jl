using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using OrderedCollections: OrderedDict

# ---- #

const JS = pkgdir(Omics, "data", "Dictionary", "example.json")

for (fi, re) in (
    (
        JS,
        OrderedDict{String, Any}(
            "1" => "1",
            "3" => "3",
            "5" => "5",
            "7" => "7",
            "8" => 8,
            "6" => 6,
            "4" => 4,
            "2" => 2,
        ),
    ),
    (
        replace(JS, "json" => "toml"),
        Dict{String, Any}(
            "clients" =>
                Dict("hosts" => ["alpha", "omega"], "data" => [["gamma", "delta"], [1, 2]]),
            "servers" => Dict(
                "beta" => Dict("dc" => "eqdc10", "ip" => "10.0.0.2"),
                "alpha" => Dict("dc" => "eqdc10", "ip" => "10.0.0.1"),
            ),
            "database" => Dict(
                "enabled" => true,
                "connection_max" => 5000,
                "ports" => [8000, 8001, 8002],
                "server" => "192.168.1.1",
            ),
            "owner" => Dict("name" => "Tom Preston-Werner"),
            "title" => "TOML Example",
        ),
    ),
)

    ke_va = Omics.Dictionary.rea(fi)

    @test ke_va == re

    @test typeof(ke_va) === typeof(re)

    @test ke_va isa OrderedDict ? collect(ke_va) == collect(re) :
          collect(ke_va) != collect(re)

end

@test typeof(Omics.Dictionary.rea(JS, OrderedDict{String, Union{Int, String}})) ===
      OrderedDict{String, Union{Int, String}}

# ---- #

for ty in (OrderedDict, Dict)

    re = ty(
        "1" => "1",
        "2" => 2,
        "3" => "3",
        "4" => 4,
        "5" => "5",
        "6" => 6,
        "7" => "7",
        "8" => 8,
    )

    ke_va =
        Omics.Dictionary.rea(Omics.Dictionary.writ(joinpath(tempdir(), "write.json"), re))

    @test ke_va == re

    @test typeof(ke_va) === OrderedDict{String, Any}

    @test collect(ke_va) == collect(re)

end
