include("environment.jl")

# ---- #

te = joinpath(tempdir(), "BioLab.test.Match")

BioLab.Path.reset(te)

# ---- #

function benchmark(n_fe, n_sa, ho)

    si = (n_fe, n_sa)

    if ho == "1.0:"

        ta_ = collect(1.0:n_sa)

        fe_x_sa_x_nu = Matrix(reshape(1.0:(n_fe * n_sa), si))

    elseif ho == "randn"

        ta_ = randn(n_sa)

        fe_x_sa_x_nu = randn(size)

    end

    BioLab.Match.cor,
    "Target",
    "Feature",
    ["Feature $id" for id in 1:n_fe],
    ["Sample $id" for id in 1:n_sa],
    ta_,
    fe_x_sa_x_nu

end

# ---- #

ar = benchmark(2, 4, "1.0:")

for rev in (false, true)

    BioLab.Match.make(ar...; rev, layout = Dict("title" => Dict("text" => "rev = $rev")))

end

# ---- #

ar = benchmark(1000, 100, "randn")

for (n_ma, n_pv) in ((0, 0), (0, 10), (10, 0), (10, 10), (100, 100))

    BioLab.Match.make(
        ar...;
        n_ma,
        n_pv,
        layout = Dict("title" => Dict("text" => "n_ma = $n_ma, n_pv = $n_pv")),
    )

end

# ---- #

n_fe = 5

ar = benchmark(n_fe, 2, "1.0:")

for n_ex in 0:(n_fe + 1)

    BioLab.Match.make(ar...; n_ex, layout = Dict("title" => Dict("text" => "n_ex = $n_ex")))

end

# ---- #

fu, trn, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(2, 4, "1.0:")

tai_ = convert(Vector{Int}, ta_)

fe_x_sa_x_it = convert(Matrix{Int}, fe_x_sa_x_nu)

for (ta_, fe_x_sa_x_nu, title_text) in (
    (ta_, fe_x_sa_x_nu, "Float x Float"),
    (tai_, fe_x_sa_x_nu, "Int x Float"),
    (ta_, fe_x_sa_x_it, "Float x Int"),
    (tai_, fe_x_sa_x_it, "Int x Int"),
)

    BioLab.Match.make(
        fu,
        trn,
        fen,
        fe_,
        sa_,
        ta_,
        fe_x_sa_x_nu;
        layout = Dict("title" => Dict("text" => title_text)),
    )

end

# ---- #

ar = fu, trn, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(2, 4, "randn")

for st in (0, 0.1, 1, 2, 4, 8)

    BioLab.Match.make(ar...; st, layout = Dict("title" => Dict("text" => "st = $st")))

end

# ---- #

for (n_fe, n_sa) in ((2, 2), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000))

    BioLab.Match.make(
        benchmark(n_fe, n_sa, "randn")...;
        n_ex = 32,
        layout = Dict("title" => Dict("text" => "$(n_fe) x $(n_sa)")),
    )

end

# ---- #

n_fe = 4

fe_ = ["Feature $id" for id in 1:n_fe]

n_gr = 3

n_sa = 6

ta_ = repeat(1:n_gr, n_sa)

# TODO: Improve.
sa_ = vec(["$gr$ch" for gr in 1:n_gr, ch in ('A':'Z')[1:n_sa]])

for rev in (false, true)

    for po_ in ((0, 0, 1, 1, 2, 3), (0, 1, 2, 3, 1, 0))

        BioLab.Match.make(
            fu,
            "Group",
            "Feature",
            fe_,
            sa_,
            ta_,
            [ro^po for ro in fill(2, n_fe), po in vcat((fill(po, n_gr) for po in po_)...)];
            rev,
            layout = Dict("title" => Dict("text" => "rev = $rev, $po_")),
        )

    end

end
