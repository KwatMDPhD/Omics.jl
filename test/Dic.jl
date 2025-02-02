using OrderedCollections: OrderedDict

using Test: @test

using Omics

# ---- #

# 101.530 μs (4155 allocations: 234.26 KiB)
# 101.331 μs (4146 allocations: 229.86 KiB)

for (ke, va, re) in (
    (
        "Existing",
        2,
        Dict("Existing" => 1, "Existing.2" => 2, "Existing.3" => 2, "Existing.4" => 2),
    ),
    ("New", 2, Dict("Existing" => 1, "New" => 2, "New.2" => 2, "New.3" => 2)),
)

    ke_va = Dict("Existing" => 1)

    for _ in 1:3

        Omics.Dic.set_with_suffix!(ke_va, ke, va)

    end

    @test ke_va == re

    #@btime Omics.Dic.set_with_suffix!($ke_va, $ke, $va) evals = 1000

end

# ---- #

# 146.522 ns (10 allocations: 768 bytes)
# 165.768 ns (10 allocations: 768 bytes)
# 149.686 ns (10 allocations: 832 bytes)

for (an_, re) in (
    (['a', 'b', 'b', 'c', 'c', 'c'], Dict('a' => [1], 'b' => [2, 3], 'c' => [4, 5, 6])),
    (
        ['c', 'b', 'a', 'a', 'a', 'b', 'b', 'c', 'c'],
        Dict('c' => [1, 8, 9], 'b' => [2, 6, 7], 'a' => [3, 4, 5]),
    ),
    ([1, 2, 3, 3, 2, 1], Dict(1 => [1, 6], 2 => [2, 5], 3 => [3, 4])),
)

    @test Omics.Dic.index(an_) == re

    #@btime Omics.Dic.index($an_)

end

# ---- #

for (k1_v1, k2_v2, re) in (
    (Dict(1 => 'a'), Dict(2 => 'b'), Dict{Int, Char}),
    (Dict(1.0 => 'a'), Dict(2 => "Bb"), Dict{Union{Int, Float64}, Union{Char, String}}),
)

    @test typeof(Omics.Dic.merg(k1_v1, k2_v2)) === re

end

# ---- #

# 798.041 ns (16 allocations: 1.50 KiB)
# 799.126 ns (16 allocations: 1.50 KiB)

const K1_V1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

const K2_V2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

for (k1_v1, k2_v2, re) in (
    (K1_V1, K2_V2, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))),
    (K2_V2, K1_V1, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))),
)

    @test Omics.Dic.merg(k1_v1, k2_v2) == re

    #@btime Omics.Dic.merg($k1_v1, $k2_v2)

end

# ---- #

const RE = pkgdir(Omics, "data", "Dic", "example.json")

# ---- #

@test typeof(Omics.Dic.rea(RE, OrderedDict{String, Union{Int, String}})) ===
      OrderedDict{String, Union{Int, String}}

# ---- #

for (fi, re) in (
    (
        RE,
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
        replace(RE, "json" => "toml"),
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

const WR = joinpath(tempdir(), "write.json")

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

    ke_va = Omics.Dic.rea(Omics.Dic.writ(WR, re))

    @test ke_va == re

    @test typeof(ke_va) === OrderedDict{String, Any}

    @test collect(ke_va) == collect(re)

end
