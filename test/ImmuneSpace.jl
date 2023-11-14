using Test: @test

using Nucleus

# ---- #

const TS_, NAR_, RO___, CO___, MA_ = Nucleus.ImmuneSpace._initialize_block()

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

    Nucleus.ImmuneSpace._push_block!(
        TS_,
        NAR_,
        RO___,
        CO___,
        MA_,
        joinpath(Nucleus.TE, "$id.tsv"),
        "Feature Set $id",
        ro_,
        co_,
        Nucleus.Simulation.make_matrix_1n(Int, lastindex(ro_), lastindex(co_)),
    )

end

# ---- #

for bl in (TS_, NAR_, RO___, CO___, MA_)

    @test lastindex(bl) === 3

end

# ---- #

const CO_ = Nucleus.ImmuneSpace._intersect_block!(CO___, MA_)

# ---- #

@test lastindex(CO_) === 2

# ---- #

for ma in MA_

    @test size(ma, 2) === 2

end

# ---- #

Nucleus.ImmuneSpace._write_block(TS_, NAR_, RO___, CO_, MA_)

# ---- #

for ts in TS_

    @test isfile(ts)

end

# ---- #

# TODO
Nucleus.ImmuneSpace.get
