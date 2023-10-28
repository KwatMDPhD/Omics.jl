# TODO: Benchmark.

using Test: @test

using Nucleus

# ---- #

function benchmark(ho, n_fe, n_sa)

    if ho == "f12"

        ta_ = collect(1.0:n_sa)

        fe_x_sa_x_nu = Nucleus.Simulation.make_matrix_1n(Float64, n_fe, n_sa)

    elseif ho == "ra"

        ta_ = Nucleus.Simulation.make_vector_mirror(cld(n_sa, 2), iseven(n_sa))

        fe_x_sa_x_nu = randn(n_fe, n_sa)

    end

    Nucleus.Match.cor,
    "1234567890123456789012345678901234567890",
    "Feature",
    "Sample",
    (id -> "Feature $id").(1:n_fe),
    (id -> "Sample $id").(1:n_sa),
    ta_,
    fe_x_sa_x_nu

end

# ---- #

Nucleus.Match.make(Nucleus.TE, benchmark("f12", 1, 2)...)

# ---- #

for ex in ("tsv", "html")

    @test isfile(joinpath(Nucleus.TE, "feature_x_statistic_x_number.$ex"))

end

# ---- #

function make_directory_layout(title_text)

    di = joinpath(Nucleus.TE, Nucleus.Path.clean(title_text))

    Nucleus.Path.remake_directory(di)

    di, Dict("title" => Dict("text" => title_text))

end

# ---- #

const SI = 100000, 100

# ---- #

for (n_fe, n_sa) in ((1, 3), (2, 3), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000), SI)

    di, layout = make_directory_layout("$n_fe x $n_sa")

    Nucleus.Match.make(di, benchmark("ra", n_fe, n_sa)...; layout)

end

# ---- #

const FU, NAT, NAF, NAS, FE_, SA_, TA_, FE_X_SA_X_NU = benchmark("f12", 1, 19)

# ---- #

const TAI_ = convert(Vector{Int}, TA_)

# ---- #

const FE_X_SA_X_IT = convert(Matrix{Int}, FE_X_SA_X_NU)

# ---- #

for (ta_, fe_x_sa_x_nu) in
    ((TA_, FE_X_SA_X_NU), (TAI_, FE_X_SA_X_NU), (TA_, FE_X_SA_X_IT), (TAI_, FE_X_SA_X_IT))

    di, layout = make_directory_layout("$(eltype(ta_)) x $(eltype(fe_x_sa_x_nu))")

    Nucleus.Match.make(di, FU, NAT, NAF, NAS, FE_, SA_, ta_, fe_x_sa_x_nu; layout)

end

# ---- #

const N_FE = 3

# ---- #

const GFE_ = (id -> "Feature $id").(1:N_FE)

# ---- #

const N_GR = 4

# ---- #

const N_CH = 6

# ---- #

const GSA_ = vec(["$gr$ch" for gr in 1:N_GR, ch in ('A':'Z')[1:N_CH]])

# ---- #

const GR_ = repeat(1:N_GR, N_CH)

# ---- #

for nu_ in ((1, 1, 2, 2, 4, 8), (1, 2, 4, 8, 2, 1))

    di, layout = make_directory_layout(string(nu_))

    Nucleus.Match.make(
        di,
        Nucleus.Match.cor,
        "Group",
        "Feature",
        "Sample",
        GFE_,
        GSA_,
        GR_,
        # TODO: Improve.
        hcat((fill(nu, N_FE, N_GR) for nu in nu_)...);
        layout,
    )

end

# ---- #

const NS_ = benchmark("ra", SI...)

# ---- #

for (n_ma, n_pv) in ((0, 0), (0, 10), (10, 0), (10, 10), (30, 30))

    di, layout = make_directory_layout("n_ma = $n_ma, n_pv = $n_pv")

    Nucleus.Match.make(di, NS_...; n_ma, n_pv, layout)

end

# ---- #

const NE_ = benchmark("f12", 5, 2)

# ---- #

for n_ex in (0, 1, 2, 3, 6)

    di, layout = make_directory_layout("n_ex = $n_ex")

    Nucleus.Match.make(di, NE_...; n_ex, layout)

end

# ---- #

const ST_ = benchmark("ra", 2, 3)

# ---- #

for st in (0, 0.1, 1, 2, 4, 8)

    di, layout = make_directory_layout("st = $st")

    Nucleus.Match.make(di, ST_...; st, layout)

end
