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

const KES_VA = Dict("Existing" => 1)

# ---- #

for (ke, va, re) in (
    (
        "Existing",
        2,
        Dict("Existing" => 1, "Existing.2" => 2, "Existing.3" => 2, "Existing.4" => 2),
    ),
    ("New", 2, Dict("Existing" => 1, "New" => 2, "New.2" => 2, "New.3" => 2)),
)

    ke_va = copy(KES_VA)

    for _ in 1:3

        BioLab.Dict.set_with_suffix!(ke_va, ke, va)

    end

    @test ke_va == re

    # 138.633 μs (4121 allocations: 275.38 KiB)
    # 138.961 μs (4112 allocations: 270.93 KiB)
    #@btime BioLab.Dict.set_with_suffix!(ke_va, $ke, $va) setup = (ke_va = copy(KES_VA)) evals =
    #    1000

end

# ---- #

for (ke1_va, ke2_va, re) in (
    (Dict(1 => 'a'), Dict(2 => 'b'), Dict{Int, Char}),
    (Dict(1.0 => 'a'), Dict(2 => "Bb"), Dict{Float64, Any}),
    (Dict(1 => "Aa"), Dict(2.0 => view("Bb", 1:2)), Dict{Float64, AbstractString}),
)

    @test typeof(BioLab.Dict.merge(ke1_va, ke2_va)) === re

end

# ---- #

const KE1_VA = Dict("1A" => 1, "B" => Dict("C" => 1, "1D" => 1))

# ---- #

const KE2_VA = Dict("2A" => 2, "B" => Dict("C" => 2, "2D" => 2))

# ---- #

for (ke1_va, ke2_va, re) in (
    (KE1_VA, KE2_VA, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 2, "1D" => 1, "2D" => 2))),
    (KE2_VA, KE1_VA, Dict("1A" => 1, "2A" => 2, "B" => Dict("C" => 1, "1D" => 1, "2D" => 2))),
)

    @test BioLab.Dict.merge(ke1_va, ke2_va) == re

    # 1.679 μs (32 allocations: 2.86 KiB)
    # 1.654 μs (32 allocations: 2.86 KiB)
    #@btime BioLab.Dict.merge($ke1_va, $ke2_va)

end

# ---- #

const AN1_ = ['A', 'B']

# ---- #

for (an_id, re) in (
    (Dict(), BitVector()),
    (Dict('A' => 1), [true]),
    (Dict('B' => 1), [true]),
    (Dict('Z' => 1), [false]),
    (Dict('A' => 1, 'B' => 2, 'Z' => 3), [true, true, false]),
    (Dict('A' => 1, 'Z' => 2, 'B' => 3), [true, false, true]),
)

    is_ = BioLab.Dict.is_in(an_id, AN1_)

    @test typeof(is_) === BitVector

    @test is_ == re

    # 37.387 ns (2 allocations: 96 bytes)
    # 33.157 ns (2 allocations: 96 bytes)
    # 33.199 ns (2 allocations: 96 bytes)
    # 32.235 ns (2 allocations: 96 bytes)
    # 32.277 ns (2 allocations: 96 bytes)
    # 32.109 ns (2 allocations: 96 bytes)
    #@btime BioLab.Dict.is_in($an_id, AN1_)

end

# ---- #

const FE_ = reverse!(
    BioLab.DataFrame.read(joinpath(DA, "gene_x_statistic_x_number.tsv"); select = [1])[!, 1],
)

# ---- #

const FE1_ = BioLab.GMT.read(joinpath(DA, "c2.all.v7.1.symbols.gmt"))["COLLER_MYC_TARGETS_UP"]

# ---- #

# 695.792 μs (6 allocations: 6.91 KiB)
#@btime in(FE1_).(FE_);
# 689.250 μs (3 allocations: 6.84 KiB)
#@btime in($FE1_).(FE_);
#@btime in(FE1_).($FE_);
#@btime in($FE1_).($FE_);

# ---- #

const FE1S = Set(FE1_)

# ---- #

# 441.500 ns (7 allocations: 1.13 KiB)
#@btime Set(FE1_);

# ---- #

# 484.334 μs (6 allocations: 6.91 KiB)
#@btime in(FE1S).(FE_);
# 461.583 μs (3 allocations: 6.84 KiB)
#@btime in($FE1S).(FE_);
#@btime in(FE1S).($FE_);
#@btime in($FE1S).($FE_);

# ---- #

const FE_ID = Dict(fe => id for (id, fe) in enumerate(FE_))

# ---- #

# 510.875 μs (7 allocations: 800.92 KiB)
#@btime Dict(fe => id for (id, fe) in enumerate(FE_));

# ---- #

# 362.577 ns (2 allocations: 2.66 KiB)
#@btime BioLab.Dict.is_in(FE_ID, FE1_);

# ---- #

const JS1 = joinpath(DA, "example_1.json")

# ---- #

for ty in (Dict{String, Any}, OrderedDict{String, Any}, OrderedDict{String, String})

    @test typeof(BioLab.Dict.read(JS1, ty)) === ty

end

# ---- #

for (fi, ty, re) in (
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

    ke_va = BioLab.Dict.read(fi)

    @test typeof(ke_va) === ty

    @test ke_va == re

end

# ---- #

const JSW = joinpath(BioLab.TE, "write_read.json")

# ---- #

const KEW_VA = Dict(
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

BioLab.Dict.write(JSW, KEW_VA)

# ---- #

const KEWR_VA = BioLab.Dict.read(JSW)

# ---- #

@test typeof(KEW_VA) != typeof(KEWR_VA)

# ---- #

@test KEW_VA == KEWR_VA
