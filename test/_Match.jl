include("_.jl")

# ---- #

te = joinpath(tempdir(), "BioLab.test.Match")

BioLab.Path.empty(te)

fu = BioLab.Match._get_pearson_correlation

# ---- #

function benchmark(n_fe, n_sa, ho)

    tan = "Target"

    fen = "Feature"

    fe_ = ["Feature $id" for id in 1:n_fe]

    sa_ = ["Sample $id" for id in 1:n_sa]

    if ho == "1.0:"

        ta_ = collect(1.0:n_sa)

    elseif ho == "randn"

        ta_ = randn(n_sa)

    else

        error()

    end

    fe_x_sa_x_nu = BioLab.Matrix.simulate(n_fe, n_sa, ho; re = 1)

    return tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu

end

# ---- #

n_fe, n_sa = (2, 4)

for ic in (true, false)

    tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(n_fe, n_sa, "1.0:")

    layout = Dict("title" => Dict("text" => "$(ifelse(ic, "Increasing", "Decreasing")) Target"))

    BioLab.Match.make(fu, tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu; ic, layout)

end

# ---- #

n_fe, n_sa = (1000, 100)

tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(n_fe, n_sa, "randn")

for (n_ma, n_pv) in ((0, 10), (10, 0), (0, 0), (10, 10), (100, 100))

    layout = Dict("title" => Dict("text" => "$n_ma and $n_pv"))

    fe_x_st_x_nu = BioLab.Match.make(fu, tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu; n_ma, n_pv, layout)

    display(sort(fe_x_st_x_nu, "Score"; rev = true))

end

# ---- #

n_fe, n_sa = (5, 2)

for n_ex in 0:(n_fe + 1)

    tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(n_fe, n_sa, "1.0:")

    layout = Dict("title" => Dict("text" => BioLab.String.count_noun(n_ex, "Extreme")))

    BioLab.Match.make(fu, tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu; n_ex, layout)

end

# ---- #

n_fe, n_sa = (2, 4)

tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(n_fe, n_sa, "1.0:")

tai_ = convert(Vector{Int}, ta_)

fe_x_sa_x_it = convert(Matrix{Int}, fe_x_sa_x_nu)

for (ta_, fe_x_sa_x_nu, title_text) in (
    (ta_, fe_x_sa_x_nu, "Float x Float"),
    (tai_, fe_x_sa_x_nu, "Int x Float"),
    (ta_, fe_x_sa_x_it, "Float x Int"),
    (tai_, fe_x_sa_x_it, "Int x Int"),
)

    layout = Dict("title" => Dict("text" => title_text))

    BioLab.Match.make(fu, tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu; layout)

end

# ---- #

n_fe, n_sa = (2, 4)

for st in (0, 0.1, 1, 2, 4, 8)

    tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(n_fe, n_sa, "randn")

    layout = Dict("title" => Dict("text" => BioLab.String.count_noun(st, "Standard Deviation")))

    BioLab.Match.make(fu, tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu; st, layout)

end

# ---- #

for (n_fe, n_sa) in ((2, 2), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000))

    tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(n_fe, n_sa, "randn")

    layout = Dict("title" => Dict("text" => "$(n_fe) by $(n_sa)"))

    BioLab.Match.make(fu, tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu; n_ex = 32, layout)

end

# ---- #

n_gr = 3

n_sa = 6

n_fe = 4

tan = "Group"

fen = "Feature"

fe_ = ["Feature $id" for id in 1:n_fe]

sa_ = vec(["$gr$ch" for gr in 1:n_gr, ch in ('A':'Z')[1:n_sa]])

ta_ = repeat(1:n_gr, n_sa)

for ic in (true, false)

    for po_ in ((0, 0, 1, 1, 2, 3), (0, 1, 2, 3, 1, 0))

        fe_x_sa_x_nu =
            [ro^po for ro in fill(2, n_fe), po in vcat((fill(po, n_gr) for po in po_)...)]

        layout = Dict("title" => Dict("text" => "$(ifelse(ic, "Increasing", "Decreasing")) $po_"))

        BioLab.Match.make(fu, tan, fen, fe_, sa_, ta_, fe_x_sa_x_nu; ic, layout)

    end

end
