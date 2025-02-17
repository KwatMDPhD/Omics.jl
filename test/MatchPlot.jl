using Random: seed!

using Statistics: cor

using Test: @test

using Omics

# ---- #

function simulate(ho, uf, us)

    vt_, vf = if ho == "12"

        collect(1.0:us), Omics.Simulation.make_matrix_1n(Float64, uf, us)

    elseif ho == "ra"

        Omics.Simulation.make_vector_mirror(cld(us, 2), iseven(us)), randn(uf, us)

    end

    Omics.Simulation.label(us, "Sample"), vt_, Omics.Simulation.label(uf, "Feature"), vf

end

# ---- #

function make_output(ti)

    mkpath(joinpath(tempdir(), ti)), Dict("title" => Dict("text" => ti))

end

# ---- #

sa_, vt_, fe_, vf = simulate("12", 1, 2)

Omics.Match.write_plot(
    tempdir(),
    "Sample",
    sa_,
    "Target",
    vt_,
    "Feature",
    fe_,
    vf,
    Omics.Match.ge(cor, vt_, vf),
)

for ex in ("tsv", "html")

    @test isfile(tempdir(), "result.$ex")

end

# ---- #

# 1.196 μs (101 allocations: 4.09 KiB)
# 2.065 μs (168 allocations: 7.27 KiB)
# 4.839 μs (345 allocations: 15.96 KiB)
# 12.166 μs (642 allocations: 36.11 KiB)
# 36.959 μs (1237 allocations: 107.55 KiB)
# 713.167 μs (5985 allocations: 1.75 MiB)
# 1.496 ms (74100 allocations: 3.54 MiB)
# 391.250 μs (514 allocations: 998.12 KiB)
# 6.065 s (7400140 allocations: 2.65 GiB)

for (uf, us) in (
    (1, 3),
    (2, 3),
    (4, 4),
    (8, 8),
    (16, 16),
    (80, 80),
    (1000, 4),
    (4, 1000),
    (100000, 100),
)

    sa_, vt_, fe_, vf = simulate("ra", uf, us)

    di, la = make_output("$uf x $us")

    Omics.Match.write_plot(
        di,
        "Sample",
        sa_,
        "Target",
        vt_,
        "Feature",
        fe_,
        vf,
        Omics.Match.ge(cor, vt_, vf);
        la,
    )

    #@btime Omics.Match.ge($cor, $vt_, $vf)

end

# ---- #

sa_, tf_, fe_, ff = simulate("12", 2, 4)

ti_ = convert(Vector{Int}, tf_)

tb_ = [false, false, true, true]

fi = convert(Matrix{Int}, ff)

for (vt_, vf) in
    ((tf_, ff), (ti_, ff), (tb_, ff), (convert(BitVector, tb_), ff), (tf_, fi), (ti_, fi))

    di, la = make_output("$(typeof(vt_)) x $(eltype(vf))")

    Omics.Match.write_plot(
        di,
        "Sample",
        sa_,
        "Target",
        vt_,
        "Feature",
        fe_,
        vf,
        Omics.Match.ge(cor, vt_, vf);
        la,
    )

end

# ---- #

sa_, vt_, fe_, vf = simulate("ra", 100000, 100)

for (u1, u2) in ((0, 0), (10, 0), (0, 10), (10, 10), (20, 20))

    di, la = make_output("u1 = $u1, u2 = $u2")

    seed!(20241226)

    Omics.Match.write_plot(
        di,
        "Sample",
        sa_,
        "Target",
        vt_,
        "Feature",
        fe_,
        vf,
        Omics.Match.ge(cor, vt_, vf; u1, u2);
        la,
    )

end

# ---- #

sa_, vt_, fe_, vf = simulate("12", 5, 2)

for ue in (1, 2, 3, 6)

    di, la = make_output("ue = $ue")

    Omics.Match.write_plot(
        di,
        "Sample",
        sa_,
        "Target",
        vt_,
        "Feature",
        fe_,
        vf,
        Omics.Match.ge(cor, vt_, vf);
        ue,
        la,
    )

end

# ---- #

sa_, vt_, fe_, vf = simulate("ra", 2, 3)

for st in (0.0, 0.1, 1.0, 2.0, 4.0)

    di, la = make_output("st = $st")

    Omics.Match.write_plot(
        di,
        "Sample",
        sa_,
        "Target",
        vt_,
        "Feature",
        fe_,
        vf,
        Omics.Match.ge(cor, vt_, vf);
        st,
        la,
    )

end

# ---- #

di, la = make_output("Skip Plotting NaN")

vt_ = [1.4, 1.3, 0.2, 0.1]

vf = [
    1 1 0 0
    1 NaN 3 4
    0.5 0.5 0.5 0.5
    0.49 0.51 0.48 0.52
    1 2 NaN 4
    0 0 1 1
]

Omics.Match.write_plot(
    di,
    "Sample",
    Omics.Simulation.label(4, "Sample"),
    "Target",
    vt_,
    "Feature",
    ["+ Correlation", 2, "Constant", "Nosie", 5, "- Correlation"],
    vf,
    Omics.Match.ge(cor, vt_, vf);
    la,
)
