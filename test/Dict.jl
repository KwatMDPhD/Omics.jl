using OrderedCollections: OrderedDict

using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Dict")

# ---- #

@test BioLab.Path.read(DA) == ["example.toml", "example_1.json", "example_2.json"]

# ---- #

const DIS = Dict("Existing" => 1)

for (ke, va, re) in (
    ("Existing", 1, Dict("Existing" => 1, "Existing.2" => 1)),
    ("Existing", 2, Dict("Existing" => 1, "Existing.2" => 2)),
    ("New", 3, Dict("Existing" => 1, "New" => 3)),
)

    co = copy(DIS)

    BioLab.Dict.set_with_suffix!(co, ke, va)

    @test co == re

end

# ---- #

for (di1, di2, re) in (
    (Dict(1 => 'a'), Dict(2 => 'b'), Dict{Int, Char}),
    (Dict(1.0 => 'a'), Dict(2 => "Bb"), Dict{Float64, Any}),
    (Dict(1.0 => "Aa"), Dict(2 => chop("Bbx")), Dict{Float64, AbstractString}),
)

    @test BioLab.Dict.merge_recursively(di1, di2) isa re

end

# ---- #

const DI1 = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

const DI2 = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

@test BioLab.Dict.merge_recursively(DI1, DI2) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))


@test BioLab.Dict.merge_recursively(DI2, DI1) ==
      Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))

# ---- #

const AN1_ = ('A', 'B')

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

const DAF = joinpath(BioLab._DA, "FeatureSetEnrichment")

const FE_ = reverse!(
    BioLab.DataFrame.read(joinpath(DAF, "gene_x_statistic_x_number.tsv"); select = [1])[!, 1],
)

const FE1_ = BioLab.GMT.read(joinpath(DAF, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

# ---- #

# 737.416 μs (2 allocations: 19.67 KiB)
#@btime [fe in $FE1_ for fe in $FE_];

# 739.250 μs (3 allocations: 6.84 KiB)
#@btime in($FE1_).($FE_);

# ---- #

const FE1S = Set(FE1_)

# 440.864 ns (7 allocations: 1.13 KiB)
#@btime Set($FE1_);

# 459.542 μs (2 allocations: 19.67 KiB)
#@btime [fe in $FE1S for fe in $FE_];

# 464.167 μs (3 allocations: 6.84 KiB)
#@btime in($FE1S).($FE_);

# ---- #

const FE_ID = Dict(fe => id for (id, fe) in enumerate(FE_))

# 508.250 μs (7 allocations: 800.92 KiB)
#@btime Dict(fe => id for (id, fe) in enumerate($FE_));

# 384.698 ns (2 allocations: 2.66 KiB)
#@btime BioLab.Dict.is_in($FE_ID, $FE1_);

# ---- #

const JS1 = joinpath(DA, "example_1.json")

# ---- #

for dicttype in (Dict, OrderedDict, OrderedDict{String, String})

    @test BioLab.Dict.read(JS1; dicttype) isa dicttype

end

# ---- #

const DIR1 = BioLab.Dict.read(JS1)

@test DIR1 isa OrderedDict{String, Any}

@test DIR1 == Dict("fruit" => "Apple", "color" => "Red", "size" => "Large")

# ---- #

const DIR2 = BioLab.Dict.read(joinpath(DA, "example_2.json"))

@test DIR2 isa OrderedDict{String, Any}

@test DIR2 == Dict(
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
)

# ---- #

const DIRT = BioLab.Dict.read(joinpath(DA, "example.toml"))

@test DIRT isa Dict{String, Any}

@test DIRT == Dict(
    "servers" => Dict(
        "alpha" => Dict("dc" => "eqdc10", "ip" => "10.0.0.1"),
        "beta" => Dict("dc" => "eqdc10", "ip" => "10.0.0.2"),
    ),
    "clients" => Dict("hosts" => ["alpha", "omega"], "data" => [["gamma", "delta"], [1, 2]]),
    "owner" => Dict("name" => "Tom Preston-Werner"),
    "title" => "TOML Example",
    "database" => Dict(
        "server" => "192.168.1.1",
        "connection_max" => 5000,
        "ports" => [8000, 8001, 8002],
        "enabled" => true,
    ),
)

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

@test DIW == BioLab.Dict.read(BioLab.Dict.write(joinpath(BioLab.TE, "write_read.json"), DIW))
