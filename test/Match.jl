using Omics

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Statistics: cor

# ---- #

const TE = joinpath(homedir(), "Downloads")

# ---- #

function make_output_argument(ti)

    mkpath(joinpath(TE, ti)), Dict("title" => Dict("text" => ti))

end

# ---- #

function _mirror(n)

    po_ = Vector{Float64}(undef, n)

    id = 1

    po_[id] = 0.0

    while id < n

        ra = randn()

        if ra < 0 || ra === -0.0

            po_[id += 1] = ra

        end

    end

    sort!(po_)

    reverse!(-po_), po_

end

function _concatenate(ne_, ze, po_)

    vcat(ne_[1:(end - !ze)], po_)

end

function make_vector_mirror(n, ze = true)

    ne_, po_ = _mirror(n)

    _concatenate(ne_, ze, po_)

end

function make_vector_mirror_deep(n, ze = true)

    ne_, po_ = _mirror(n)

    _concatenate(2ne_, ze, po_)

end

function make_vector_mirror_wide(n, ze = true)

    ne_, po_ = _mirror(n)

    new_ = Vector{Float64}(undef, 2n - 1)

    for (id, ne) in enumerate(ne_)

        id2 = 2id

        new_[id2 - 1] = ne

        if id < n

            new_[id2] = 0.5(ne + ne_[id + 1])

        end

    end

    _concatenate(new_, ze, po_)

end

function make_matrix_1n(ty, n_ro, n_co)

    Matrix{ty}(reshape(1:(n_ro * n_co), n_ro, n_co))

end

# ---- #

function make_argument(ho, uf, us)

    if ho == "f12"

        ta_ = collect(1.0:us)

        fe_x_sa_x_nu = make_matrix_1n(Float64, uf, us)

    elseif ho == "ra"

        ta_ = make_vector_mirror(cld(us, 2), iseven(us))

        fe_x_sa_x_nu = randn(uf, us)

    end

    cor,
    "Sample",
    (id -> "Sample $id").(1:us),
    "1234567890123456789012345678901234567890",
    ta_,
    "Feature",
    (id -> "Feature $id").(1:uf),
    fe_x_sa_x_nu

end

# ---- #

Omics.Match.make(TE, make_argument("f12", 1, 2)...)

# ---- #

for ex in ("tsv", "html")

    @test isfile(joinpath(TE, "feature_x_statistic_x_number.$ex"))

end

# ---- #

const SI = 100000, 100

# ---- #

for (uf, us) in
    ((1, 3), (2, 3), (4, 4), (8, 8), (16, 16), (80, 80), (1000, 4), (4, 1000), SI)

    di, la = make_output_argument("$uf x $us")

    Omics.Match.make(di, make_argument("ra", uf, us)...; la)

end

# ---- #

const FU, NAS, SA_, NAT, TA_, NAF, FE_, FE_X_SA_X_NU = make_argument("f12", 1, 19)

# ---- #

const TAI_ = convert(Vector{Int}, TA_)

# ---- #

const FE_X_SA_X_IT = convert(Matrix{Int}, FE_X_SA_X_NU)

# ---- #

for (ta_, fe_x_sa_x_nu) in
    ((TA_, FE_X_SA_X_NU), (TAI_, FE_X_SA_X_NU), (TA_, FE_X_SA_X_IT), (TAI_, FE_X_SA_X_IT))

    di, la = make_output_argument("$(eltype(ta_)) x $(eltype(fe_x_sa_x_nu))")

    Omics.Match.make(di, FU, NAS, SA_, NAT, ta_, NAF, FE_, fe_x_sa_x_nu; la)

end

# ---- #

const uf = 3

# ---- #

const GFE_ = (id -> "Feature $id").(1:uf)

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

    di, la = make_output_argument(string(nu_))

    Omics.Match.make(
        di,
        cor,
        "Sample",
        GSA_,
        "Group",
        GR_,
        "Feature",
        GFE_,
        hcat((fill(nu, uf, N_GR) for nu in nu_)...);
        la,
    )

end

# ---- #

const NS_ = make_argument("ra", SI...)

# ---- #

for (um, up) in ((0, 0), (0, 10), (10, 0), (10, 10), (30, 30))

    di, la = make_output_argument("um = $um, up = $up")

    Omics.Match.make(di, NS_...; um, up, la)

end

# ---- #

const NE_ = make_argument("f12", 5, 2)

# ---- #

for ue in (0, 1, 2, 3, 6)

    di, la = make_output_argument("ue = $ue")

    Omics.Match.make(di, NE_...; ue, la)

end

# ---- #

const ST_ = make_argument("ra", 2, 3)

# ---- #

for st in (0, 0.1, 1, 2, 4, 8)

    di, la = make_output_argument("st = $st")

    Omics.Match.make(di, ST_...; st, la)

end
