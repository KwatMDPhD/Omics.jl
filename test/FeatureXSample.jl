using Test: @test

using Nucleus

# ---- #

const TS_, NAR_, RO___, CO___, MA_ = Nucleus.FeatureXSample.initialize_block()

# ---- #

for (bl, re) in
    zip((TS_, NAR_, RO___, CO___, MA_), (String, String, Vector{String}, Vector{String}, Matrix))

    @test eltype(bl) === re

    @test isempty(bl)

end

# ---- #

for (id, (ro_, co_)) in enumerate((
    (["F 1 1", "F 1 2"], ["S1", "S2", "S3", "S4"]),
    (["F 2 1", "F 2 2"], ["S2", "S3", "S4", "S5"]),
    (["F 3 1", "F 3 2"], ["S3", "S4", "S5", "S6"]),
))

    ts = joinpath(Nucleus.TE, "$id.tsv")

    nar = "Feature Set $id"

    ma = Nucleus.Simulation.make_matrix_1n(Int, lastindex(ro_), lastindex(co_))

    Nucleus.FeatureXSample.push_block!(TS_, NAR_, RO___, CO___, MA_, ts, nar, ro_, co_, ma)

end

# ---- #

for bl in (TS_, NAR_, RO___, CO___, MA_)

    @test lastindex(bl) === 3

end

# ---- #

for ze in (0, 0.0)

    @test Nucleus.Error.@is Nucleus.FeatureXSample._error_0(0)

end

# ---- #

for nu in (1, 2.0)

    @test !Nucleus.Error.@is Nucleus.FeatureXSample._error_0(nu)

end

# ---- #

const CO_ = Nucleus.FeatureXSample.intersect_column!(CO___, MA_)

# ---- #

@test lastindex(CO_) === 2

# ---- #

for ma in MA_

    @test size(ma, 2) === 2

end

# ---- #

@test Nucleus.Error.@is Nucleus.FeatureXSample.intersect_column(1:2, 3:5, [1 2], [3 4 5])

# ---- #

#disable_logging(Info)

# ---- #

for (co1_, co2_, ro_x_co1_x_an, ro_x_co2_x_an, re) in (
    (1:1, 1:2, [1;;], [1 2], (1:1, [1;;], [1;;])),
    (1:2, 1:2, [1 2], [1 2], (1:2, [1 2], [1 2])),
    (1:3, 2:4, [1 2 3], [2 3 4], (2:3, [2 3], [2 3])),
)

    @test Nucleus.FeatureXSample.intersect_column(co1_, co2_, ro_x_co1_x_an, ro_x_co2_x_an) == re

    # 441.919 ns (16 allocations: 1.52 KiB)
    # 458.122 ns (16 allocations: 1.55 KiB)
    # 488.186 ns (16 allocations: 1.55 KiB)
    #@btime Nucleus.FeatureXSample.intersect_column($co1_, $co2_, $ro_x_co1_x_an, $ro_x_co2_x_an)

end

# ---- #

#disable_logging(Debug)

# ---- #

Nucleus.FeatureXSample.write_block(TS_, NAR_, RO___, CO_, MA_)

# ---- #

for ts in TS_

    @test isfile(ts)

end

# ---- #

for (na_, an___) in ((
    ["Row", "Column 1", "Column 2", "Column 3"],
    ([1, 2, 3], ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']),
),)

    Nucleus.FeatureXSample.count_unique(na_, an___)

end

# ---- #

const RO_ = (id -> "Row $id").([1, 1, 2, 3, 2, 3, 4])

# ---- #

const ROU_ = unique(RO_)

# ---- #

const RO2U_ = replace.(ROU_, "Row" => "New Row")

# ---- #

@test Nucleus.FeatureXSample.transform(
    RO_,
    (id -> "Column $id").(1:3),
    [-1.0; 1; 0; -2; 2; 8; 7;;];
    ro_ro2 = Dict(zip(ROU_, RO2U_)),
    lo = true,
) == (RO2U_, [0.0; 1; 2; 3;;])
