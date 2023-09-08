module Match

using Printf: @sprintf

using ProgressMeter: @showprogress

using Random: shuffle!

using Statistics: cor

using StatsBase: sample

using ..BioLab

function _order_sample(id_, sa_, ta_, fe_x_sa_x_nu)

    view(sa_, id_), view(ta_, id_), view(fe_x_sa_x_nu, :, id_)

end

function _align!(it::AbstractArray{Int}, ::Real)

    minimum(it), maximum(it)

end

function _align!(fl_::AbstractVector{Float64}, st::Real)

    if allequal(fl_)

        @warn "All floats are $(fl_[1])."

        fl_ .= 0

    else

        BioLab.Normalization.normalize_with_0!(fl_)

        clamp!(fl_, -st, st)

    end

    -st, st

end

function _align!(fe_x_sa_x_fl::AbstractMatrix{Float64}, st::Real)

    foreach(fl_ -> _align!(fl_, st), eachrow(fe_x_sa_x_fl))

    -st, st

end

const _FONT_FAMILY_1 = "Gravitas One"

const _FONT_FAMILY_2 = "Droid Serif"

const _FONT_SIZE_1 = 16

const _FONT_SIZE_2 = 12.8

const _ANNOTATION =
    Dict("yref" => "paper", "xref" => "paper", "showarrow" => false, "yanchor" => "middle")

const _ANNOTATIONR = BioLab.Dict.merge_recursively(
    _ANNOTATION,
    Dict("xanchor" => "center", "font" => Dict("family" => _FONT_FAMILY_2)),
)

function _get_x(id)

    0.97 + id * 0.088

end

function _annotate_statistic(y, la, th, fe_, fe_x_st_x_nu)

    annotations = Vector{Dict{String, Any}}()

    if la

        for (idx, text) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                annotations,
                BioLab.Dict.merge_recursively(
                    _ANNOTATIONR,
                    Dict(
                        "y" => y,
                        "x" => _get_x(idx),
                        "text" => "<b>$text</b>",
                        "font" => Dict("size" => _FONT_SIZE_1),
                    ),
                ),
            )

        end

    end

    y -= th

    for idy in eachindex(fe_)

        sc, ma, pv, ad = (@sprintf("%.2g", nu) for nu in view(fe_x_st_x_nu, idy, :))

        for (idx, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                BioLab.Dict.merge_recursively(
                    _ANNOTATIONR,
                    Dict(
                        "y" => y,
                        "x" => _get_x(idx),
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

function _plot(ht, nat, naf, nas, fe_, sa_, ta_, fe_x_sa_x_nu, fe_x_st_x_nu, st, layout)

    if ta_ isa AbstractVector{Int}

        @info "Clustering within groups"

        id_ = Vector{Int}()

        fu = BioLab.Clustering.Euclidean()

        for ta in unique(ta_)

            idg_ = findall(==(ta), ta_)

            append!(
                id_,
                view(
                    idg_,
                    BioLab.Clustering.hierarchize(view(fe_x_sa_x_nu, :, idg_), 2; fu).order,
                ),
            )

        end

        sa_, ta_, fe_x_sa_x_nu = _order_sample(id_, sa_, ta_, fe_x_sa_x_nu)

    end

    tac_ = copy(ta_)

    tai, taa = _align!(tac_, st)

    @info "$nat colors can range from $tai to $taa."

    fe_x_sa_x_nuc = copy(fe_x_sa_x_nu)

    fei, fea = _align!(fe_x_sa_x_nuc, st)

    @info "$naf colors can range from $fei to $fea."

    heatmap = Dict(
        "type" => "heatmap",
        "colorbar" => BioLab.Dict.merge_recursively(BioLab.Plot.COLORBAR, Dict("y" => 0.5)),
    )

    n_ro = length(fe_) + 2

    th = 1 / n_ro

    th2 = th / 2

    height = max(640, 40 * n_ro)

    n_sa = length(sa_)

    n_li = 28

    natl = BioLab.String.limit(nat, n_li)

    axis = Dict(
        "tickcolor" => "#6c9956",
        "tickfont" => Dict("family" => _FONT_FAMILY_1, "size" => _FONT_SIZE_1),
    )

    BioLab.Plot.plot(
        ht,
        [
            BioLab.Dict.merge_recursively(
                heatmap,
                Dict(
                    "yaxis" => "y2",
                    "y" => ["<b>$natl</b>"],
                    "x" => sa_,
                    "z" => [tac_],
                    "text" => [ta_],
                    "hoverinfo" => "x+z+text",
                    "zmin" => tai,
                    "zmax" => taa,
                    "colorscale" => BioLab.Color.fractionate(BioLab.Color.pick_color_scheme(tac_)),
                    "colorbar" => Dict("x" => -0.32, "title" => Dict("text" => "Target")),
                ),
            ),
            BioLab.Dict.merge_recursively(
                heatmap,
                Dict(
                    "y" => BioLab.String.limit.(fe_, n_li),
                    "x" => sa_,
                    "z" => collect(eachrow(fe_x_sa_x_nuc)),
                    "text" => collect(eachrow(fe_x_sa_x_nu)),
                    "hoverinfo" => "y+x+z+text",
                    "zmin" => fei,
                    "zmax" => fea,
                    "colorscale" =>
                        BioLab.Color.fractionate(BioLab.Color.pick_color_scheme(fe_x_sa_x_nuc)),
                    "colorbar" => Dict("x" => -0.24, "title" => Dict("text" => "Feature")),
                ),
            ),
        ],
        BioLab.Dict.merge_recursively(
            Dict(
                "margin" => Dict("l" => 220, "r" => 220),
                "height" => height,
                "width" => 1200,
                "title" => Dict(
                    "text" => naf,
                    "font" => Dict("family" => _FONT_FAMILY_1, "size" => _FONT_SIZE_1 * 2),
                ),
                "yaxis2" => BioLab.Dict.merge_recursively(axis, Dict("domain" => (1 - th, 1))),
                "yaxis" => BioLab.Dict.merge_recursively(
                    axis,
                    Dict("domain" => (0, 1 - th * 2), "autorange" => "reversed"),
                ),
                "xaxis" => BioLab.Dict.merge_recursively(
                    axis,
                    Dict("title" => Dict("text" => BioLab.String.count(n_sa, nas))),
                ),
                "annotations" => _annotate_statistic(1 - th2 * 3, true, th, fe_, fe_x_st_x_nu),
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

    n_nos = BioLab.String.count(n_fe, naf)

    @info "Matching $nat and $n_nos with $fu"

    sa_, ta_, fe_x_sa_x_nu = _order_sample(sortperm(ta_), sa_, ta_, fe_x_sa_x_nu)

    @info "Computing scores"

    sc_ = (nu_ -> fu(ta_, nu_)).(eachrow(fe_x_sa_x_nu))

    is_ = isnan.(sc_)

    if any(is_)

        @warn "Found $(BioLab.String.count(sum(is_), "bad value"))."

    end

    ma_ = fill(NaN, n_fe)

    pv_ = fill(NaN, n_fe)

    ad_ = fill(NaN, n_fe)

    if 0 < n_ma

        @info "Computing margin of error with $(BioLab.String.count(n_ma, "sampling"))"

        n_sm = ceil(Int, n_sa * 0.632)

        @showprogress for idf in 1:n_fe

            ra_ = Vector{Float64}(undef, n_ma)

            nu_ = view(fe_x_sa_x_nu, idf, :)

            for idr in 1:n_ma

                ids_ = sample(1:n_sa, n_sm; replace = false)

                ra_[idr] = fu(view(ta_, ids_), view(nu_, ids_))

            end

            ma_[idf] = BioLab.Statistics.get_margin_of_error(ra_)

        end

    end

    if 0 < n_pv

        @info "Computing p-values with $(BioLab.String.count(n_pv, "permutation"))"

        co = copy(ta_)

        ra_ = Vector{Float64}(undef, n_fe * n_pv)

        idr = 0

        @showprogress for idf in 1:n_fe

            nu_ = view(fe_x_sa_x_nu, idf, :)

            for _ in 1:n_pv

                ra_[idr += 1] = fu(shuffle!(co), nu_)

            end

        end

        pv_, ad_ = BioLab.Statistics.get_p_value(sc_, ra_)

    end

    fe_x_st_x_nu = hcat(sc_, ma_, pv_, ad_)

    pr = joinpath(di, "feature_x_statistic_x_number")

    BioLab.DataFrame.write(
        "$pr.tsv",
        BioLab.DataFrame.make(
            naf,
            fe_,
            ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
            fe_x_st_x_nu,
        ),
    )

    if 0 < n_ex

        id_ = reverse!(BioLab.Rank.get_extreme(view(fe_x_st_x_nu, :, 1), n_ex))

        _plot(
            "$pr.html",
            nat,
            naf,
            nas,
            view(fe_, id_),
            sa_,
            ta_,
            view(fe_x_sa_x_nu, id_, :),
            view(fe_x_st_x_nu, id_, :),
            st,
            layout,
        )

    end

    fe_x_st_x_nu

end

end
