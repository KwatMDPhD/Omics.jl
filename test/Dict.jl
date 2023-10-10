using OrderedCollections: OrderedDict

using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Dict")

# ---- #

@test BioLab.Path.read(DA) == [
    "c2.all.v7.1.symbols.gmt",
    "example.toml",
    "example_1.json",
    "example_2.json",
    "gene_x_statistic_x_number.tsv",
]

# ---- #

const DIS = Dict("Existing" => 1)

# ---- #

for (ke, va, re) in (
    (
        "Existing",
        2,
        Dict("Existing" => 1, "Existing.2" => 2, "Existing.3" => 2, "Existing.4" => 2),
    ),
    ("New", 2, Dict("Existing" => 1, "New" => 2, "New.2" => 2, "New.3" => 2)),
)

    co = copy(DIS)

    for _ in 1:3

        BioLab.Dict.set_with_suffix!(co, ke, va)

    end

    @test co == re

    # 125.000 ns (5 allocations: 256 bytes)
    # 0.001 ns (0 allocations: 0 bytes)
    @btime BioLab.Dict.set_with_suffix!(co, $ke, $va) setup = (co = copy($DIS)) evals = 1

end

# ---- #

for (di1, di2, re) in (
    (Dict(1 => 'a'), Dict(2 => 'b'), Dict{Int, Char}),
    (Dict(1.0 => 'a'), Dict(2 => "Bb"), Dict{Float64, Any}),
    (Dict(1.0 => "Aa"), Dict(2 => view("Bb", 1:2)), Dict{Float64, AbstractString}),
)

    @test BioLab.Dict.merge(di1, di2) isa re

end

# ---- #

const DI1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

# ---- #

const DI2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

# ---- #

for (di1, di2, re) in (
    (DI1, DI2, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))),
    (DI2, DI1, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))),
)

    @test BioLab.Dict.merge(di1, di2) == re

    # 1.700 μs (32 allocations: 2.86 KiB)
    # 1.729 μs (32 allocations: 2.86 KiB)
    @btime BioLab.Dict.merge($di1, $di2)

end

# ---- #

const AN1_ = ['A', 'B']

# ---- #

for (an_id, re) in (
    (Dict(), ()),
    (Dict('A' => 1), (true,)),
    (Dict('B' => 1), (true,)),
    (Dict('Z' => 1), (false,)),
    (Dict('A' => 1, 'B' => 2, 'Z' => 3), (true, true, false)),
    (Dict('A' => 1, 'Z' => 2, 'B' => 3), (true, false, true)),
)

    is_ = BioLab.Dict.is_in(an_id, AN1_)

    @test is_ isa BitVector

    @test is_ == collect(re)

end

# ---- #

const FE_ = reverse!(
    BioLab.DataFrame.read(joinpath(DA, "gene_x_statistic_x_number.tsv"); select = [1])[!, 1],
)

# ---- #

const FE1_ = BioLab.GMT.read(joinpath(DA, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

# ---- #

# 687.375 μs (2 allocations: 19.67 KiB)
@btime [fe in $FE1_ for fe in $FE_];

# ---- #

# 689.208 μs (3 allocations: 6.84 KiB)
@btime in($FE1_).($FE_);

# ---- #

const FE1S = Set(FE1_)

# ---- #

# 442.131 ns (7 allocations: 1.13 KiB)
@btime Set($FE1_);

# ---- #

# 465.708 μs (2 allocations: 19.67 KiB)
@btime [fe in $FE1S for fe in $FE_];

# ---- #

# 468.833 μs (3 allocations: 6.84 KiB)
@btime in($FE1S).($FE_);

# ---- #

const FE_ID = BioLab.Collection.map_index(FE_)

# ---- #

# 510.958 μs (7 allocations: 800.92 KiB)
@btime BioLab.Collection.map_index($FE_);

# ---- #

for ke in ("Missing", "GPI")

    # 8.675 ns (0 allocations: 0 bytes)
    # 9.425 ns (0 allocations: 0 bytes)
    # 13.555 ns (0 allocations: 0 bytes)
    # 11.094 ns (0 allocations: 0 bytes)

    @btime $ke in $FE1S

    @btime haskey($FE_ID, $ke)

end

# ---- #

# 362.582 ns (2 allocations: 2.66 KiB)
@btime BioLab.Dict.is_in($FE_ID, $FE1_);

# ---- #

const JS1 = joinpath(DA, "example_1.json")

# ---- #

for ty in (Dict, OrderedDict, OrderedDict{String, String})

    @test BioLab.Dict.read(JS1, ty) isa ty

end

# ---- #

for (pa, ty, re) in (
    (JS1, OrderedDict{String, Any}, Dict("fruit" => "Apple", "color" => "Red", "size" => "Large")),
    (
        joinpath(DA, "example_2.json"),
        OrderedDict{String, Any},
        Dict(
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
        Dict{String, Any},
        Dict(
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

    di = BioLab.Dict.read(pa)

    @test di isa ty

    @test di == re

end

# ---- #

const DIW = Dict(
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

const JSW = joinpath(BioLab.TE, "write_read.json")

# ---- #

BioLab.Dict.write(JSW, DIW)

# ---- #

const DIWR = BioLab.Dict.read(JSW)

# ---- #

@test typeof(DIW) != typeof(DIWR)

# ---- #

@test DIW == DIWR
