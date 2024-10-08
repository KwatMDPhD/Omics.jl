using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using OrderedCollections: OrderedDict

# ---- #

for (k1_v1, k2_v2, re) in (
    (Dict(1 => 'a'), Dict(2 => 'b'), Dict{Int, Char}),
    (Dict(1.0 => 'a'), Dict(2 => "Bb"), Dict{Union{Int, Float64}, Union{Char, String}}),
    (
        Dict(1 => "Aa"),
        Dict(2 => view("Bb", 1:2)),
        Dict{Int, Union{String, SubString{String}}},
    ),
)

    @test typeof(Omics.Dictionary.merg(k1_v1, k2_v2)) === re

end

const K1_V1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

const K2_V2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

for (k1_v1, k2_v2, re) in (
    (K1_V1, K2_V2, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))),
    (K2_V2, K1_V1, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))),
)

    @test Omics.Dictionary.merg(k1_v1, k2_v2) == re

    # 1.025 μs (16 allocations: 1.50 KiB)
    # 1.021 μs (16 allocations: 1.50 KiB)
    #@btime Omics.Dictionary.merg($k1_v1, $k2_v2)

end

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
