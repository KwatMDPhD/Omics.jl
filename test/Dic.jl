using OrderedCollections: OrderedDict

using Test: @test

using Omics

# ---- #

# 9.663 μs (425 allocations: 24.43 KiB)
# 9.355 μs (417 allocations: 23.56 KiB)

for (ke, va, re) in (
    ("Existing", 2, Dict("Existing" => 1, "Existing.2" => 2, "Existing.3" => 2)),
    ("New", 2, Dict("Existing" => 1, "New" => 2, "New.2" => 2)),
)

    di = Dict("Existing" => 1)

    Omics.Dic.set_with_suffix!(di, ke, va)

    Omics.Dic.set_with_suffix!(di, ke, va)

    @test di == re

    #@btime Omics.Dic.set_with_suffix!($di, $ke, $va) evals = 100

end

# ---- #

# 165.803 ns (10 allocations: 768 bytes)
# 146.004 ns (10 allocations: 832 bytes)

for (an_, re) in (
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

for (d1, d2, re) in (
    (Dict(1 => 'a'), Dict(2 => 'b'), Dict{Int, Char}),
    (Dict(1.0 => 'a'), Dict(2 => "Bb"), Dict{Union{Float64, Int}, Union{Char, String}}),
)

    @test typeof(Omics.Dic.merg(d1, d2)) === re

end

# ---- #

# 1.600 μs (24 allocations: 1.62 KiB)
# 1.617 μs (24 allocations: 1.62 KiB)

const D1 = Dict("1A" => 1, 'B' => Dict('C' => 1, "1D" => 1))

const D2 = Dict("2A" => 2, 'B' => Dict('C' => 2, "2D" => 2))

for (d1, d2, re) in (
    (D1, D2, Dict("1A" => 1, "2A" => 2, 'B' => Dict('C' => 2, "1D" => 1, "2D" => 2))),
    (D2, D1, Dict("1A" => 1, "2A" => 2, 'B' => Dict('C' => 1, "1D" => 1, "2D" => 2))),
)

    @test Omics.Dic.merg(d1, d2) == re

    #@btime Omics.Dic.merg($d1, $d2)

end

# ---- #

const JS = pkgdir(Omics, "data", "Dic", "example.json")

# ---- #

@test typeof(Omics.Dic.rea(JS, OrderedDict{String, Union{Int, String}})) ===
      OrderedDict{String, Union{Int, String}}

# ---- #

for (js, re) in (
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

    di = Omics.Dic.rea(js)

    @test di == re

    @test typeof(di) === typeof(re)

    @test di isa OrderedDict ? collect(di) == collect(re) : collect(di) != collect(re)

end

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

    js = joinpath(tempdir(), "$ty.json")

    Omics.Dic.writ(js, re)

    di = Omics.Dic.rea(js)

    @test di == re

    @test typeof(di) === OrderedDict{String, Any}

    @test collect(di) == collect(re)

end
