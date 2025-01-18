using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Random: seed!

using Statistics: cor

# ---- #

function make_output(ti)

    mkpath(joinpath(tempdir(), ti)), Dict("title" => Dict("text" => ti))

end

# ---- #

function make_argument(ho, uf, us)

    ta_, da = if ho == "12"

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
    da

end

# ---- #

Omics.Match.go(tempdir(), make_argument("12", 1, 2)...)

for ex in ("tsv", "html")

    @test isfile(joinpath(tempdir(), "match.$ex"))

end

# ---- #

const SI = 100000, 100

# ---- #

# 45.125 μs (204 allocations: 4.01 MiB)
# 47.083 μs (285 allocations: 4.01 MiB)
# 51.250 μs (479 allocations: 4.02 MiB)
# 61.166 μs (815 allocations: 4.04 MiB)
# 90.167 μs (1525 allocations: 4.12 MiB)
# 828.958 μs (7166 allocations: 5.84 MiB)
# 2.111 ms (96618 allocations: 8.17 MiB)
# 459.417 μs (653 allocations: 5.03 MiB)
# 6.052 s (9897592 allocations: 2.79 GiB)
for (uf, us) in
    ((1, 3), (2, 3), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000), SI)

    di, la = make_output("$uf x $us")

    ar_ = make_argument("ra", uf, us)

    Omics.Match.go(di, ar_...; la)

    #@btime Omics.Match.go($di, $ar_...; ue = 0)

end

# ---- #

const FU, NS, SA_, NT, TF_, NF, FE_, DF = make_argument("12", 1, 4)

const TI_ = convert(Vector{Int}, TF_)

const DI = convert(Matrix{Int}, DF)

for (ta_, da) in ((TF_, DF), (TI_, DF), (TF_, DI), (TI_, DI))

    di, la = make_output("$(eltype(ta_)) x $(eltype(da))")

    Omics.Match.go(di, FU, NS, SA_, NT, ta_, NF, FE_, da; la)

end

# ---- #

const AS_ = make_argument("ra", SI...)

for (um, uv) in ((0, 0), (10, 0), (0, 10), (10, 10), (20, 20))

    di, la = make_output("um = $um, uv = $uv")

    seed!(20241226)

    Omics.Match.go(di, AS_...; um, uv, la)

end

# ---- #

const AE_ = make_argument("12", 5, 2)

for ue in (0, 1, 2, 3, 6)

    di, la = make_output("ue = $ue")

    Omics.Match.go(di, AE_...; ue, la)

end

# ---- #

const AT_ = make_argument("ra", 2, 3)

for st in (0.0, 0.1, 1.0, 2.0, 4.0)

    di, la = make_output("st = $st")

    Omics.Match.go(di, AT_...; st, la)

end
