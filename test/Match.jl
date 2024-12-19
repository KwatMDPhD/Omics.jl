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

    ta_, fs = if ho == "f12"

        collect(1.0:us), Omics.Simulation.make_matrix_1n(Float64, uf, us)

    elseif ho == "ra"

        Omics.Simulation.make_vector_mirror(cld(us, 2), iseven(us)), randn(uf, us)

    end

    cor,
    "Sample",
    Omics.Simulation.label(us, "Sample"),
    "Target",
    ta_,
    "Feature",
    Omics.Simulation.label(uf, "Feature"),
    fs

end

# ---- #

Omics.Match.go(TE, make_argument("f12", 1, 2)...)

for ex in ("tsv", "html")

    @test isfile(joinpath(TE, "feature_x_statistic_x_number.$ex"))

end

# ---- #

const SI = 100000, 100

# ---- #

# 44.833 μs (204 allocations: 4.01 MiB)
# 45.000 μs (285 allocations: 4.01 MiB)
# 50.208 μs (479 allocations: 4.02 MiB)
# 60.416 μs (814 allocations: 4.04 MiB)
# 90.667 μs (1523 allocations: 4.12 MiB)
# 828.833 μs (7166 allocations: 5.85 MiB)
# 2.085 ms (96619 allocations: 8.17 MiB)
# 457.459 μs (652 allocations: 5.03 MiB)
# 6.066 s (9897592 allocations: 2.79 GiB)
for (uf, us) in
    ((1, 3), (2, 3), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000), SI)

    di, la = make_output("$uf x $us")

    ar_ = make_argument("ra", uf, us)

    Omics.Match.go(di, ar_...; la)

    @btime Omics.Match.go($di, $ar_...; ue = 0)

end

# ---- #

const FU, NS, SA_, NT, TA_, NF, FE_, FS = make_argument("f12", 1, 19)

const TI_ = convert(Vector{Int}, TA_)

const FI = convert(Matrix{Int}, FS)

for (ta_, fs) in ((TA_, FS), (TI_, FS), (TA_, FI), (TI_, FI))

    di, la = make_output("$(eltype(ta_)) x $(eltype(fs))")

    Omics.Match.go(di, FU, NS, SA_, NT, ta_, NF, FE_, fs; la)

end

# ---- #

const AS_ = make_argument("ra", SI...)

for (um, uv) in ((0, 0), (0, 10), (10, 0), (10, 10), (40, 40))

    di, la = make_output("um = $um, uv = $uv")

    Omics.Match.go(di, AS_...; um, uv, la)

end

# ---- #

const AE_ = make_argument("f12", 5, 2)

for ue in (0, 1, 2, 3, 6)

    di, la = make_output("ue = $ue")

    Omics.Match.go(di, AE_...; ue, la)

end

# ---- #

const AC_ = make_argument("ra", 2, 3)

for st in (0, 0.1, 1, 2, 4, 8)

    di, la = make_output("st = $st")

    Omics.Match.go(di, AC_...; st, la)

end
