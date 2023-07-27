using StatsBase: mean

using Test: @test

using BioLab

# ---- #

function benchmark(n_fe, n_sa, ho)

    si = n_fe, n_sa

    if ho == "12"

        ta_ = collect(1.0:n_sa)

        fe_x_sa_x_nu = BioLab.Simulation.make_matrix_1n(n_fe, n_sa, Float64)

    elseif ho == "ra"

        ta_ = BioLab.Simulation.make_vector_mirror(cld(n_sa, 2); ze = iseven(n_sa))

        fe_x_sa_x_nu = randn(si)

    end

    BioLab.Match.cor,
    "Target",
    "Feature",
    "Sample",
    ["Feature $id" for id in 1:n_fe],
    ["Sample $id" for id in 1:n_sa],
    ta_,
    fe_x_sa_x_nu

end

# ---- #

function make_directory_layout(title_text)

    mkdir(joinpath(BioLab.TE, BioLab.Path.clean(title_text))),
    Dict("title" => Dict("text" => title_text))

end

# ---- #

@test BioLab.Error.@is_error BioLab.Match.make("", benchmark(1, 1, "12")...)

# ---- #

const REA_ = benchmark(1, 2, "12")

for rev in (false, true)

    di, layout = make_directory_layout("rev = $rev")

    BioLab.Match.make(di, REA_...; rev, layout)

end

# ---- #

const NA_ = benchmark(50000, 100, "ra")

for (n_ma, n_pv) in ((0, 0), (0, 10), (10, 0), (10, 10), (40, 40))

    di, layout = make_directory_layout("n_ma = $n_ma, n_pv = $n_pv")

    BioLab.Match.make(di, NA_...; n_ma, n_pv, layout)

end

# ---- #

const EXA_ = benchmark(5, 2, "12")

for n_ex in (0, 1, 2, 3, 6)

    di, layout = make_directory_layout("n_ex = $n_ex")

    BioLab.Match.make(di, EXA_...; n_ex, layout)

end

# ---- #

const FU, NAT, NAF, NAS, FE_, SA_, TA_, FE_X_SA_X_NU = benchmark(1, 19, "12")

const TAI_ = convert(Vector{Int}, TA_)

const FE_X_SA_X_IT = convert(Matrix{Int}, FE_X_SA_X_NU)

for (ta_, fe_x_sa_x_nu) in
    ((TA_, FE_X_SA_X_NU), (TAI_, FE_X_SA_X_NU), (TA_, FE_X_SA_X_IT), (TAI_, FE_X_SA_X_IT))

    tyt = eltype(ta_)

    tyf = eltype(fe_x_sa_x_nu)

    di, layout = make_directory_layout("$tyt x $tyf")

    BioLab.Match.make(di, FU, NAT, NAF, NAS, FE_, SA_, ta_, fe_x_sa_x_nu; layout)

end

# ---- #

const STA_ = benchmark(2, 3, "ra")

for st in (0, 0.1, 1, 2, 4, 8)

    di, layout = make_directory_layout("st = $st")

    BioLab.Match.make(di, STA_...; st, layout)

end

# ---- #

for (n_fe, n_sa) in ((1, 3), (2, 3), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000))

    di, layout = make_directory_layout("$n_fe x $n_sa")

    BioLab.Match.make(di, benchmark(n_fe, n_sa, "ra")...; n_ex = 40, layout)

end

# ---- #

const N_FE = 3

const GFE_ = string.("Feature ", 1:N_FE)

const N_GR = 4

const N_RE = 6

const GSA_ = vec(["$ch $gr" for gr in 1:N_GR, ch in ('A':'Z')[1:N_RE]])

const GTA_ = repeat(1:N_GR, N_RE)

for nu_ in ((1, 1, 2, 2, 4, 8), (1, 2, 4, 8, 2, 1))

    ar_ = BioLab.Match.cor,
    "Group",
    "Feature",
    "Sample",
    GFE_,
    GSA_,
    GTA_,
    hcat((fill(nu, (N_FE, N_GR)) for nu in nu_)...)

    for rev in (false, true)

        di, layout = make_directory_layout("$nu_, rev = $rev")

        BioLab.Match.make(di, ar_...; rev, layout)

    end

end
