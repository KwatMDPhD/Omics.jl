using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using OrderedCollections: OrderedDict

# ---- #

for (an_, re) in (
    (['a', 'b', 'c', 'd'], Dict('a' => 1, 'b' => 2, 'c' => 3, 'd' => 4)),
    (
        ['a', 'a', 'b', 'b', 'c', 'c', 'd', 'd'],
        Dict('a' => 1, 'b' => 2, 'c' => 3, 'd' => 4),
    ),
    (
        ['a', 'a', 'c', 'c', 'd', 'd', 'b', 'b'],
        Dict('a' => 1, 'c' => 2, 'd' => 3, 'b' => 4),
    ),
)

    @test Omics.Dic.index(an_) == re

    # 69.757 ns (4 allocations: 384 bytes)
    # 79.636 ns (4 allocations: 384 bytes)
    # 79.510 ns (4 allocations: 384 bytes)
    #@btime Omics.Dic.index($an_)

end

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

    @test typeof(Omics.Dic.merg(k1_v1, k2_v2)) === re

end

# ---- #

const K1_V1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

const K2_V2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

for (k1_v1, k2_v2, re) in (
    (K1_V1, K2_V2, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))),
    (K2_V2, K1_V1, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))),
)

    @test Omics.Dic.merg(k1_v1, k2_v2) == re

    # 1.008 μs (16 allocations: 1.50 KiB)
    # 1.008 μs (16 allocations: 1.50 KiB)
    #@btime Omics.Dic.merg($k1_v1, $k2_v2)

end

# ---- #

const JS = pkgdir(Omics, "data", "Dic", "example.json")

# ---- #

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

    ke_va = Omics.Dic.rea(fi)

    @test ke_va == re

    @test typeof(ke_va) === typeof(re)

    @test ke_va isa OrderedDict ? collect(ke_va) == collect(re) :
          collect(ke_va) != collect(re)

end

# ---- #

@test typeof(Omics.Dic.rea(JS, OrderedDict{String, Union{Int, String}})) ===
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

    ke_va = Omics.Dic.rea(Omics.Dic.writ(joinpath(tempdir(), "write.json"), re))

    @test ke_va == re

    @test typeof(ke_va) === OrderedDict{String, Any}

    @test collect(ke_va) == collect(re)

end
