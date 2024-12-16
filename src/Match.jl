module Match

using Distances: CorrDist

using ProgressMeter: @showprogress

using Random: shuffle!

using StatsBase: mean, quantile, sample

using ..Omics

function _order(id_, sa_, ta_, fe_x_sa_x_nu)

    sa_[id_], ta_[id_], fe_x_sa_x_nu[:, id_]

end

function _align!(it, ::Real)

    extrema(it)

end

function _align!(fl_::AbstractVector{<:AbstractFloat}, st::Real)

    if allequal(fl_)

        @warn "All numbers are $(fl_[1])."

        fl_ .= 0.0

    else

        Omics.Normalization.normalize_with_0!(fl_)

        clamp!(fl_, -st, st)

    end

    -st, st

end

function _align!(fe_x_sa_x_fl::AbstractMatrix{<:AbstractFloat}, st::Real)

    foreach(fl_ -> _align!(fl_, st), eachrow(fe_x_sa_x_fl))

    -st, st

end

const _FONT_FAMILY = "Gravitas One"

const _FONT_SIZE = 16

const _ANNOTATION = Dict(
    "yref" => "paper",
    "xref" => "paper",
    "yanchor" => "middle",
    "xanchor" => "center",
    "showarrow" => false,
    "font" => Dict("family" => "Droid Serif"),
)

function _get_x(id)

    0.977 + 0.088id

end

function _annotate(y, la, th, fe_, fe_x_st_x_fl)

    annotations = Dict{String, Any}[]

    if la

        for (id, text) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                annotations,
                Omics.Dic.merg(
                    _ANNOTATION,
                    Dict(
                        "y" => y,
                        "x" => _get_x(id),
                        "text" => "<b>$text</b>",
                        "font" => Dict("size" => _FONT_SIZE),
                    ),
                ),
            )

        end

    end

    y -= th

    for id in eachindex(fe_)

        sc, ma, pv, ad = (Omics.Strin.shorten(fl) for fl in view(fe_x_st_x_fl, id, :))

        for (id, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                Omics.Dic.merg(
                    _ANNOTATION,
                    Dict(
                        "y" => y,
                        "x" => _get_x(id),
                        "text" => text,
                        "font" => Dict("size" => 13),
                    ),
                ),
            )

        end

        y -= th

    end

    annotations

end

function _plot(ht, nat, naf, nas, fe_, sa_, ta_, fe_x_sa_x_nu, fe_x_st_x_fl, st, la)

    if eltype(ta_) <: Integer

        @info "Clustering within groups"

        sa_, ta_, fe_x_sa_x_nu = _order(
            Omics.Clustering.order(CorrDist(), ta_, eachcol(fe_x_sa_x_nu)),
            sa_,
            ta_,
            fe_x_sa_x_nu,
        )

    end

    tac_ = copy(ta_)

    fe_x_sa_x_nuc = copy(fe_x_sa_x_nu)

    tai, taa = _align!(tac_, st)

    fei, fea = _align!(fe_x_sa_x_nuc, st)

    @info "\"$nat\" colors can range from $tai to $taa."

    @info "\"$naf\" colors can range from $fei to $fea."

    n_ro = lastindex(fe_) + 2

    th = 1 / n_ro

    th2 = 0.5th

    n_li = 30

    axis = Dict(
        "tickcolor" => "#6c9956",
        "tickfont" => Dict("family" => _FONT_FAMILY, "size" => _FONT_SIZE),
    )

    Omics.Plot.plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "name" => "Target",
                "yaxis" => "y2",
                "y" => ["<b>$nat</b>"],
                "x" => sa_,
                "z" => [tac_],
                "text" => [ta_],
                "zmin" => tai,
                "zmax" => taa,
                "colorscale" => Omics.Palette.fractionate(Omics.Palette.pick(tac_)),
                "colorbar" => Dict(
                    "y" => 0.5,
                    "x" => -0.32,
                    "len" => 0.4,
                    "thickness" => 16,
                    "title" => Dict("text" => "Target"),
                    "tickvals" => Omics.Plot.make_tickvals(tac_),
                    "tickfont" => Dict("family" => "Monospace", "size" => 16),
                ),
            ),
            Dict(
                "type" => "heatmap",
                "name" => "Feature",
                "y" => fe_,
                "x" => sa_,
                "z" => collect(eachrow(fe_x_sa_x_nuc)),
                "text" => collect(eachrow(fe_x_sa_x_nu)),
                "zmin" => fei,
                "zmax" => fea,
                "colorscale" =>
                    Omics.Palette.fractionate(Omics.Palette.pick(fe_x_sa_x_nuc)),
                "colorbar" => Dict(
                    "y" => 0.5,
                    "x" => -0.24,
                    "len" => 0.4,
                    "thickness" => 16,
                    "title" => Dict("text" => "Feature"),
                    "tickvals" => Omics.Plot.make_tickvals(fe_x_sa_x_nuc),
                    "tickfont" => Dict("family" => "Monospace", "size" => 16),
                ),
            ),
        ),
        Omics.Dic.merg(
            Dict(
                "margin" => Dict("l" => 220, "r" => 220),
                "height" => max(640, 40n_ro),
                "width" => 1280,
                "title" =>
                    Dict("font" => Dict("family" => _FONT_FAMILY, "size" => 2_FONT_SIZE)),
                "yaxis2" => merge(axis, Dict("domain" => (1 - th, 1))),
                "yaxis" =>
                    merge(axis, Dict("domain" => (0, 1 - 2th), "autorange" => "reversed")),
                "xaxis" => merge(
                    axis,
                    Dict(
                        "automargin" => true,
                        "title" =>
                            Dict("text" => Omics.Strin.coun(lastindex(sa_), nas)),
                    ),
                ),
                "annotations" => _annotate(1 - 3th2, true, th, fe_, fe_x_st_x_fl),
            ),
            la,
        ),
    )

end

function make(
    di,
    fu,
    nas,
    sa_,
    nat,
    ta_,
    naf,
    fe_,
    fe_x_sa_x_nu;
    ts = "feature_x_statistic_x_number",
    um = 10,
    up = 10,
    ue = 8,
    st = 4,
    la = Dict{String, Any}(),
)

    n_fe, n_sa = size(fe_x_sa_x_nu)

    @info "🩰 Matching \"$nat\" and $(Omics.Strin.coun(n_fe, "\"$naf\"")) with `$fu`"

    sa_, ta_, fe_x_sa_x_nu = _order(sortperm(ta_), sa_, ta_, fe_x_sa_x_nu)

    @info "Calculating scores"

    sc_ = (nu_ -> fu(ta_, nu_)).(eachrow(fe_x_sa_x_nu))

    is_ = isnan.(sc_)

    if any(is_)

        @warn "Scores have $(Omics.Strin.coun(sum(is_), "NaN"))."

    end

    ma_ = fill(NaN, n_fe)

    pv_ = fill(NaN, n_fe)

    ad_ = fill(NaN, n_fe)

    if 0 < um

        @info "Calculating the margin of errors using $(Omics.Strin.coun(um, "sampling"))"

        ra_ = Vector{Float64}(undef, um)

        id_ = 1:n_sa

        n_sm = round(Int, 0.632n_sa)

        ids_ = Vector{Int}(undef, n_sm)

        @showprogress for id in 1:n_fe

            nu_ = fe_x_sa_x_nu[id, :]

            for id in 1:um

                ids_ .= sample(id_, n_sm; replace = false)

                ra_[id] = fu(ta_[ids_], nu_[ids_])

            end

            ma_[id] = Omics.Significance.get_margin_of_error(ra_)

        end

    end

    if 0 < up

        @info "Calculating p-values using $(Omics.Strin.coun(up, "permutation"))"

        co = copy(ta_)

        fe_x_id_x_ra = Matrix{Float64}(undef, n_fe, up)

        @showprogress for idf in 1:n_fe

            nu_ = fe_x_sa_x_nu[idf, :]

            for idr in 1:up

                fe_x_id_x_ra[idf, idr] = fu(shuffle!(co), nu_)

            end

        end

        idn_ = findall(<(0), sc_)

        idp_ = findall(>=(0), sc_)

        np_, na_, pp_, pa_ = Omics.Significance.get_p_value(fe_x_id_x_ra, sc_, idn_, idp_)

        pv_[idn_] = np_

        pv_[idp_] = pp_

        ad_[idn_] = na_

        ad_[idp_] = pa_

    end

    fe_x_st_x_fl = hcat(sc_, ma_, pv_, ad_)

    pr = joinpath(di, ts)

    Omics.Table.writ(
        "$pr.tsv",
        Omics.Table.make(
            naf,
            fe_,
            ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
            fe_x_st_x_fl,
        ),
    )

    if 0 < ue

        id_ = reverse!(Omics.Rank.get_extreme(sc_, ue))

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
            la,
        )

    end

    fe_x_st_x_fl

end

function summarize_top(st, qu = 0.99)

    ab_ = abs.(view(st, :, 1))

    mean(filter!(>=(quantile(ab_, qu)), ab_))

end

function summarize_significant(st, ad = 0.1)

    ns = ab = 0

    for i1 in 1:size(st, 1)

        if st[i1, 4] < ad

            ns += 1

            ab += abs(st[i1, 1])

        end

    end

    iszero(ns) ? 0.0 : ab / ns

end

end
