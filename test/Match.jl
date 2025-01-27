using Random: seed!

using Statistics: cor

using Test: @test

using Omics

# ---- #

function make_argument(ho, uf, us)

    vt_, vf = if ho == "12"

        collect(1.0:us), Omics.Simulation.make_matrix_1n(Float64, uf, us)

    elseif ho == "ra"

        Omics.Simulation.make_vector_mirror(cld(us, 2), iseven(us)), randn(uf, us)

    end

    cor,
    "Sample",
    Omics.Simulation.label(us, "Sample"),
    "Target",
    vt_,
    "Feature",
    Omics.Simulation.label(uf, "Feature"),
    vf

end

# ---- #

function make_output(ti)

    mkpath(joinpath(tempdir(), ti)), Dict("title" => Dict("text" => ti))

end

# ---- #

fu, ns, sa_, nt, vt_, nf, fe_, vf = make_argument("12", 1, 2)

Omics.Match.write_plot(
    tempdir(),
    ns,
    sa_,
    nt,
    vt_,
    nf,
    fe_,
    vf,
    Omics.Match.ge(fu, vt_, vf),
)

for ex in ("tsv", "html")

    @test isfile(tempdir(), "result.$ex")

end

# ---- #

const SI = 100000, 100

# ---- #

# 1.229 μs (101 allocations: 4.09 KiB)
# 2.139 μs (168 allocations: 7.27 KiB)
# 4.965 μs (343 allocations: 15.85 KiB)
# 12.375 μs (642 allocations: 36.19 KiB)
# 37.292 μs (1236 allocations: 107.27 KiB)
# 716.375 μs (5985 allocations: 1.75 MiB)
# 1.513 ms (74100 allocations: 3.54 MiB)
# 392.250 μs (512 allocations: 998.02 KiB)
# 5.893 s (7400140 allocations: 2.65 GiB)

for (uf, us) in
    ((1, 3), (2, 3), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000), SI)

    fu, ns, sa_, nt, vt_, nf, fe_, vf = make_argument("ra", uf, us)

    di, la = make_output("$uf x $us")

    Omics.Match.write_plot(
        di,
        ns,
        sa_,
        nt,
        vt_,
        nf,
        fe_,
        vf,
        Omics.Match.ge(fu, vt_, vf);
        la,
    )

    #@btime Omics.Match.ge($fu, $vt_, $vf)

end

# ---- #

fu, ns, sa_, nt, tf_, nf, fe_, ff = make_argument("12", 2, 4)

ti_ = convert(Vector{Int}, tf_)

tb_ = [false, false, true, true]

fi = convert(Matrix{Int}, ff)

for (vt_, vf) in
    ((tf_, ff), (ti_, ff), (tb_, ff), (convert(BitVector, tb_), ff), (tf_, fi), (ti_, fi))

    di, la = make_output("$(typeof(vt_)) x $(eltype(vf))")

    Omics.Match.write_plot(
        di,
        ns,
        sa_,
        nt,
        vt_,
        nf,
        fe_,
        vf,
        Omics.Match.ge(fu, vt_, vf);
        la,
    )

end

# ---- #

fu, ns, sa_, nt, vt_, nf, fe_, vf = make_argument("ra", SI...)

for (um, uv) in ((0, 0), (10, 0), (0, 10), (10, 10), (20, 20))

    di, la = make_output("um = $um, uv = $uv")

    seed!(20241226)

    Omics.Match.write_plot(
        di,
        ns,
        sa_,
        nt,
        vt_,
        nf,
        fe_,
        vf,
        Omics.Match.ge(fu, vt_, vf; um, uv);
        la,
    )

end

# ---- #

fu, ns, sa_, nt, vt_, nf, fe_, vf = make_argument("12", 5, 2)

for ue in (1, 2, 3, 6)

    di, la = make_output("ue = $ue")

    Omics.Match.write_plot(
        di,
        ns,
        sa_,
        nt,
        vt_,
        nf,
        fe_,
        vf,
        Omics.Match.ge(fu, vt_, vf);
        ue,
        la,
    )

end

# ---- #

fu, ns, sa_, nt, vt_, nf, fe_, vf = make_argument("ra", 2, 3)

for st in (0.0, 0.1, 1.0, 2.0, 4.0)

    di, la = make_output("st = $st")

    Omics.Match.write_plot(
        di,
        ns,
        sa_,
        nt,
        vt_,
        nf,
        fe_,
        vf,
        Omics.Match.ge(fu, vt_, vf);
        st,
        la,
    )

end

# ---- #

di, la = make_output("Skip Plotting NaN")

vt_ = [0.1, 0.2, 1.3, 1.4]

vf = [
    1 1 0 0
    NaN NaN NaN NaN
    0.49 0.51 0.49 0.51
    NaN NaN NaN NaN
    0 0 1 1
    NaN NaN NaN NaN
]

Omics.Match.write_plot(
    di,
    "Sample",
    Omics.Simulation.label(4, "Sample"),
    "Target",
    vt_,
    "Feature",
    ["-", "1 NaN", "Constant", "2 NaN", "+", "3 NaN"],
    vf,
    Omics.Match.ge(cor, vt_, vf);
    la,
)
