using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Statistics: cor

# ---- #

const TE = tempdir()

# ---- #

function make_output(ti)

    mkpath(joinpath(TE, ti)), Dict("title" => Dict("text" => ti))

end

# ---- #

function make_argument(ho, uf, us)

    if ho == "f12"

        ta_ = collect(1.0:us)

        fs = Omics.Simulation.make_matrix_1n(Float64, uf, us)

    elseif ho == "ra"

        ta_ = Omics.Simulation.make_vector_mirror(cld(us, 2), iseven(us))

        fs = randn(uf, us)

    end

    cor,
    "Sample",
    (id -> "Sample $id").(1:us),
    "Target",
    ta_,
    "Feature",
    (id -> "Feature $id").(1:uf),
    fs

end

# ---- #

Omics.Match.go(TE, make_argument("f12", 1, 2)...)

for ex in ("tsv", "html")

    @test isfile(joinpath(TE, "feature_x_statistic_x_number.$ex"))

end

# ---- #

const SI = 100000, 100

for (uf, us) in
    ((1, 3), (2, 3), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000), SI)

    di, la = make_output("$uf x $us")

    Omics.Match.go(di, make_argument("ra", uf, us)...; la)

end

# ---- #

const FU, NS, SA_, NT, TA_, NF, FE_, fs = make_argument("f12", 1, 19)

const TR_ = convert(Vector{Int}, TA_)

const FA = convert(Matrix{Int}, fs)

for (ta_, fs) in ((TA_, fs), (TR_, fs), (TA_, FA), (TR_, FA))

    di, la = make_output("$(eltype(ta_)) x $(eltype(fs))")

    Omics.Match.go(di, FU, NS, SA_, NT, ta_, NF, FE_, fs; la)

end

# ---- #

AR_ = make_argument("ra", SI...)

for (um, up) in ((0, 0), (0, 10), (10, 0), (10, 10), (30, 30))

    di, la = make_output("um = $um, up = $up")

    Omics.Match.go(di, AR_...; um, up, la)

end

# ---- #

AR_ = make_argument("f12", 5, 2)

for ue in (0, 1, 2, 3, 6)

    di, la = make_output("ue = $ue")

    Omics.Match.go(di, AR_...; ue, la)

end

# ---- #

AR_ = make_argument("ra", 2, 3)

for st in (0, 0.1, 1, 2, 4, 8)

    di, la = make_output("st = $st")

    Omics.Match.go(di, AR_...; st, la)

end
