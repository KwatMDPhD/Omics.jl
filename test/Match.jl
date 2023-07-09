using Test: @test

# ---- #

function benchmark(n_fe, n_sa, ho)

    si = n_fe, n_sa

    if ho == "12"

        ta_ = collect(1.0:n_sa)

        fe_x_sa_x_nu = Matrix(reshape(1.0:(n_fe * n_sa), si))

    elseif ho == "ra"

        ta_ = randn(n_sa)

        fe_x_sa_x_nu = randn(si)

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

ar = benchmark(1, 2, "12")

for rev in (false, true)

    BioLab.Match.make(
        mkdir(joinpath(TE, BioLab.Time.stamp())),
        ar...;
        rev,
        layout = Dict("title" => Dict("text" => "rev = $rev")),
    )

end

# ---- #

ar = benchmark(50000, 100, "ra")

for (n_ma, n_pv) in ((0, 0), (0, 10), (10, 0), (10, 10), (100, 100))

    BioLab.Match.make(
        mkdir(joinpath(TE, BioLab.Time.stamp())),
        ar...;
        n_ma,
        n_pv,
        layout = Dict("title" => Dict("text" => "n_ma = $n_ma, n_pv = $n_pv")),
    )

end

# ---- #

n_fe = 5

ar = benchmark(n_fe, 2, "12")

for n_ex in (0, 1, 2, 3, 6)

    BioLab.Match.make(
        mkdir(joinpath(TE, BioLab.Time.stamp())),
        ar...;
        n_ex,
        layout = Dict("title" => Dict("text" => "n_ex = $n_ex")),
    )

end

# ---- #

fu, trn, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(1, 19, "12")

tai_ = convert(Vector{Int}, ta_)

fe_x_sa_x_it = convert(Matrix{Int}, fe_x_sa_x_nu)

for (ta_, fe_x_sa_x_nu) in
    ((ta_, fe_x_sa_x_nu), (tai_, fe_x_sa_x_nu), (ta_, fe_x_sa_x_it), (tai_, fe_x_sa_x_it))

    tyt = eltype(ta_)

    tyf = eltype(fe_x_sa_x_nu)

    BioLab.Match.make(
        mkdir(joinpath(TE, BioLab.Time.stamp())),
        fu,
        trn,
        fen,
        fe_,
        sa_,
        ta_,
        fe_x_sa_x_nu;
        layout = Dict("title" => Dict("text" => "$tyt x $tyf")),
    )

end

# ---- #

ar = fu, trn, fen, fe_, sa_, ta_, fe_x_sa_x_nu = benchmark(2, 3, "ra")

for st in (0, 0.1, 1, 2, 4, 8)

    BioLab.Match.make(
        mkdir(joinpath(TE, BioLab.Time.stamp())),
        ar...;
        st,
        layout = Dict("title" => Dict("text" => "st = $st")),
    )

end

# ---- #

for (n_fe, n_sa) in ((1, 2), (2, 2), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000))

    BioLab.Match.make(
        mkdir(joinpath(TE, BioLab.Time.stamp())),
        benchmark(n_fe, n_sa, "ra")...;
        n_ex = 40,
        layout = Dict("title" => Dict("text" => "$n_fe x $n_sa")),
    )

end

# ---- #

n_fe = 3

fe_ = ["Feature $id" for id in 1:n_fe]

n_gr = 4

n_sa = 6

ta_ = repeat(1:n_gr, n_sa)

sa_ = vec(["$ch $gr" for gr in 1:n_gr, ch in ('A':'Z')[1:n_sa]])

for nu_ in ((1, 1, 2, 2, 4, 8), (1, 2, 4, 8, 2, 1))

    ar = fu, "Group", "Feature", fe_, sa_, ta_, hcat((fill(nu, (n_fe, n_gr)) for nu in nu_)...)

    for rev in (false, true)

        BioLab.Match.make(
            mkdir(joinpath(TE, BioLab.Time.stamp())),
            ar...;
            rev,
            layout = Dict("title" => Dict("text" => "$nu_, rev = $rev")),
        )

    end

end
