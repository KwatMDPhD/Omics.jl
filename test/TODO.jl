using Test: @test

using Nucleus

# ---- #

using LinearAlgebra: norm

using Random: seed!

using StatsBase: mean

# ---- #

const NS = "Cells"

const _NI, _IR_, SA_, IS =
    Nucleus.DataFrame.separate("../../../pro/Data.pro/output/combine/information_x_cell_x_any.tsv")

# ---- #

const DA_ = IS[1, :]

const TI_ = IS[8, :]

SA_ .= ("$(replace(da, "GSE" => "")) $ti $id" for (id, (da, ti)) in enumerate(zip(DA_, TI_)))

# ---- #

const NF, FE_, _SF_, FS =
    Nucleus.DataFrame.separate("../../../pro/Data.pro/output/combine/common_x_cell_x_number.tsv")

# ---- #

foreach(Nucleus.Normalization.normalize_with_125254!, eachcol(FS))

foreach(Nucleus.Normalization.normalize_with_01!, eachcol(FS))

@assert all(>=(0), FS)

# ---- #

const DS_ = ("GSE107011",)#sort!(unique(DA_))

const UF = 8

const TO = 1e-6

const UI = 10^4

const wi = 3200

# ---- #

seed!(20240420)

id_ = [da in DS_ for da in DA_]

const TW, TH =
    Nucleus.MatrixFactorization.factorize(FS[:, id_], UF; init = :random, tol = TO, maxiter = UI)

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "st.html"), TH; x = SA_[id_], gc_ = DA_[id_], wi)

# ---- #

function _initialize(ur, uc, ma, uf)

    rand(ur, uc) * sqrt(mean(ma) / uf)

end

function _initialize_w(ma, uf)

    _initialize(size(ma, 1), uf, ma, uf)

end

function _initialize_h(ma, uf)

    _initialize(uf, size(ma, 2), ma, uf)

end

function _has_converged(no___, to)

    n1_ = no___[end - 1]

    ne_ = no___[end]

    if all((n1_ .- ne_) ./ n1_ .<= to)

        @info "Converged with $(lastindex(no___)) iterations."

        true

    else

        false

    end

end

function _zero!(nu_)

    ep = eps()

    for id in eachindex(nu_)

        if nu_[id] < ep

            nu_[id] = 0

        end

    end

end

function factorize_wide(ma_, uf, to, ui)

    n1 = norm(ma_[1])

    we_ = [n1 / norm(ma) for ma in ma_]

    mw = _initialize_w(ma_[1], uf)

    mh_ = Tuple(_initialize_h(ma, uf) for ma in ma_)

    no___ = [[norm(ma - mw * mh) for (ma, mh) in zip(ma_, mh_)]]

    for ii in 1:ui

        mw .*=
            sum(we * ma * transpose(mh) for (we, ma, mh) in zip(we_, ma_, mh_)) ./
            sum(we * mw * mh * transpose(mh) for (we, mh) in zip(we_, mh_))

        _zero!(mw)

        for (ma, mh) in zip(ma_, mh_)

            mh .*= (transpose(mw) * ma) ./ (transpose(mw) * mw * mh)

            _zero!(mh)

        end

        no_ = [norm(ma - mw * mh) for (ma, mh) in zip(ma_, mh_)]

        push!(no___, no_)

        if _has_converged(no___, to)

            break

        end

    end

    (mw,), mh_, no___

end

# ---- #

seed!(20240420)

id___ = [DA_ .== ds for ds in DS_]

const IW_, IH_, NO___ = factorize_wide(Tuple(FS[:, id_] for id_ in id___), UF, TO, UI)

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "si.html"),
    hcat(IH_...);
    x = vcat((SA_[id_] for id_ in id___)...),
    gc_ = vcat((DA_[id_] for id_ in id___)...),
    wi,
)
