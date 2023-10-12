module Match

using Printf: @sprintf

using ProgressMeter: @showprogress

using Random: shuffle!

using Statistics: cor

using StatsBase: sample

using ..BioLab

function _index(id_, sa_, ta_, fe_x_sa_x_nu)

    sa_[id_], ta_[id_], fe_x_sa_x_nu[:, id_]

end

function _align!(fl_::AbstractVector{<:AbstractFloat}, st::Real)

    if allequal(fl_)

        @warn "All numbers are $(fl_[1])."

        fl_ .= 0

    else

        BioLab.Normalization.normalize_with_0!(fl_)

        clamp!(fl_, -st, st)

    end

    -st, st

end

function _align!(fe_x_sa_x_fl::AbstractMatrix{<:AbstractFloat}, st::Real)

    foreach(fl_ -> _align!(fl_, st), eachrow(fe_x_sa_x_fl))

    -st, st

end

function _align!(it, ::Real)

    BioLab.Collection.get_minimum_maximum(it)

end

const _FONT_FAMILY_1 = "Gravitas One"

const _FONT_FAMILY_2 = "Droid Serif"

const _FONT_SIZE_1 = 16

const _FONT_SIZE_2 = 13

const _ANNOTATION = Dict(
    "yref" => "paper",
    "xref" => "paper",
    "yanchor" => "middle",
    "xanchor" => "center",
    "showarrow" => false,
    "font" => Dict("family" => _FONT_FAMILY_2),
)

function _get_x(id)

    0.97 + id * 0.088

end

# TODO: Benchmark.
function _annotate_statistic(y, la, th, fe_, fe_x_st_x_fl)

    annotations = Vector{Dict{String, Any}}()

    if la

        for (id, text) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                annotations,
                BioLab.Dict.merge(
                    _ANNOTATION,
                    Dict(
                        "y" => y,
                        "x" => _get_x(id),
                        "text" => "<b>$text</b>",
                        "font" => Dict("size" => _FONT_SIZE_1),
                    ),
                ),
            )

        end

    end

    y -= th

    for id1 in eachindex(fe_)

        sc, ma, pv, ad = (@sprintf("%.2g", fl) for fl in fe_x_st_x_fl[id1, :])

        for (id2, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                BioLab.Dict.merge(
                    _ANNOTATION,
                    Dict(
                        "y" => y,
                        "x" => _get_x(id2),
                        "text" => text,
                        "font" => Dict("size" => _FONT_SIZE_2),
                    ),
                ),
            )

        end

        y -= th

    end

    annotations

end

function _plot(ht, nat, naf, nas, fe_, sa_, ta_, fe_x_sa_x_nu, fe_x_st_x_fl, st, layout)

    if eltype(ta_) <: Integer

        @info "Clustering within groups"

        sa_, ta_, fe_x_sa_x_nu =
            _index(BioLab.Clustering.order(ta_, fe_x_sa_x_nu), sa_, ta_, fe_x_sa_x_nu)

    end

    tac_ = copy(ta_)

    tai, taa = _align!(tac_, st)

    @info "\"$nat\" colors can range from $tai to $taa."

    fe_x_sa_x_nuc = copy(fe_x_sa_x_nu)

    fei, fea = _align!(fe_x_sa_x_nuc, st)

    @info "\"$naf\" colors can range from $fei to $fea."

    n_ro = length(fe_) + 2

    th = 1 / n_ro

    th2 = th / 2

    height = max(640, 40 * n_ro)

    n_sa = length(sa_)

    n_li = 28

    axis = Dict(
        "tickcolor" => "#6c9956",
        "tickfont" => Dict("family" => _FONT_FAMILY_1, "size" => _FONT_SIZE_1),
    )

    BioLab.Plot.plot(
        ht,
        [
            Dict(
                "type" => "heatmap",
                "name" => "Target",
                "yaxis" => "y2",
                "y" => ["<b>$(BioLab.String.limit(nat, n_li))</b>"],
                "x" => sa_,
                "z" => [tac_],
                "text" => [ta_],
                "zmin" => tai,
                "zmax" => taa,
                "colorscale" => BioLab.Color.fractionate(BioLab.Color.pick_color_scheme(tac_)),
                "colorbar" => merge(
                    BioLab.Plot.COLORBAR,
                    Dict("y" => 0.5, "x" => -0.32, "title" => Dict("text" => "Target")),
                ),
            ),
            Dict(
                "type" => "heatmap",
                "name" => "Feature",
                "y" => BioLab.String.limit.(fe_, n_li),
                "x" => sa_,
                "z" => collect(eachrow(fe_x_sa_x_nuc)),
                "text" => collect(eachrow(fe_x_sa_x_nu)),
                "zmin" => fei,
                "zmax" => fea,
                "colorscale" =>
                    BioLab.Color.fractionate(BioLab.Color.pick_color_scheme(fe_x_sa_x_nuc)),
                "colorbar" => merge(
                    BioLab.Plot.COLORBAR,
                    Dict("y" => 0.5, "x" => -0.24, "title" => Dict("text" => "Feature")),
                ),
            ),
        ],
        BioLab.Dict.merge(
            Dict(
                "margin" => Dict("l" => 220, "r" => 220),
                "height" => height,
                "width" => 1200,
                "title" => Dict(
                    "text" => naf,
                    "font" => Dict("family" => _FONT_FAMILY_1, "size" => _FONT_SIZE_1 * 2),
                ),
                "yaxis2" => merge(axis, Dict("domain" => (1 - th, 1))),
                "yaxis" =>
                    merge(axis, Dict("domain" => (0, 1 - th * 2), "autorange" => "reversed")),
                "xaxis" =>
                    merge(axis, Dict("title" => Dict("text" => BioLab.String.count(n_sa, nas)))),
                "annotations" => _annotate_statistic(1 - th2 * 3, true, th, fe_, fe_x_st_x_fl),
            ),
            layout,
        ),
    )

end

function make(
    di,
    fu,
    nat,
    naf,
    nas,
    fe_,
    sa_,
    ta_,
    fe_x_sa_x_nu;
    n_ma = 10,
    n_pv = 10,
    n_ex = 8,
    st = 4,
    layout = Dict{String, Any}(),
)

    BioLab.Error.error_missing(di)

    n_fe, n_sa = size(fe_x_sa_x_nu)

    @info "Matching \"$nat\" and $(BioLab.String.count(n_fe, "\"$naf\"")) with `$fu`"

    sa_, ta_, fe_x_sa_x_nu = _index(sortperm(ta_), sa_, ta_, fe_x_sa_x_nu)

    @info "Calculating scores"

    sc_ = (nu_ -> fu(ta_, nu_)).(eachrow(fe_x_sa_x_nu))

    is_ = isnan.(sc_)

    if any(is_)

        @warn "Scores have $(BioLab.String.count(sum(is_), "NaN"))."

    end

    ma_ = fill(NaN, n_fe)

    pv_ = fill(NaN, n_fe)

    ad_ = fill(NaN, n_fe)

    if 0 < n_ma

        @info "Calculating the margin of errors using $(BioLab.String.count(n_ma, "sampling"))"

        n_sm = ceil(Int, n_sa * 0.632)

        @showprogress for idf in 1:n_fe

            ra_ = Vector{Float64}(undef, n_ma)

            nu_ = fe_x_sa_x_nu[idf, :]

            for idr in 1:n_ma

                ids_ = sample(1:n_sa, n_sm; replace = false)

                ra_[idr] = fu(ta_[ids_], nu_[ids_])

            end

            ma_[idf] = BioLab.Statistics.get_margin_of_error(ra_)

        end

    end

    if 0 < n_pv

        @info "Calculating p-values using $(BioLab.String.count(n_pv, "permutation"))"

        co = copy(ta_)

        fe_x_id_x_ra = Matrix{Float64}(undef, n_fe, n_pv)

        @showprogress for idf in 1:n_fe

            nu_ = fe_x_sa_x_nu[idf, :]

            for idr in 1:n_pv

                fe_x_id_x_ra[idf, idr] = fu(shuffle!(co), nu_)

            end

        end

        idn_ = findall(BioLab.Number.is_negative, sc_)

        idp_ = findall(BioLab.Number.is_positive, sc_)

        np_, na_, pp_, pa_ = BioLab.Statistics.get_p_value(sc_, idn_, idp_, fe_x_id_x_ra)

        pv_[idn_] = np_

        pv_[idp_] = pp_

        ad_[idn_] = na_

        ad_[idp_] = pa_

    end

    fe_x_st_x_fl = hcat(sc_, ma_, pv_, ad_)

    pr = joinpath(di, "feature_x_statistic_x_number")

    BioLab.DataFrame.write(
        "$pr.tsv",
        BioLab.DataFrame.make(
            naf,
            fe_,
            ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
            fe_x_st_x_fl,
        ),
    )

    if 0 < n_ex

        id_ = reverse!(BioLab.Rank.get_extreme(fe_x_st_x_fl[:, 1], n_ex))

        _plot(
            "$pr.html",
            nat,
            naf,
            nas,
            fe_[id_],
            sa_,
            ta_,
            fe_x_sa_x_nu[id_, :],
            fe_x_st_x_fl[id_, :],
            st,
            layout,
        )

    end

end

end
