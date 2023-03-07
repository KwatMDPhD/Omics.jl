module Match

using Printf: @sprintf

using Random: seed!, shuffle!

using Statistics: cor

using StatsBase: sample

using ..BioLab

function _normalize!(fl_::AbstractVector{Float64}, st)

    BioLab.Normalization.normalize_with_0!(fl_)

    clamp!(fl_, -st, st)

    return -st, st

end

function _normalize!(fe_x_sa_x_fl::AbstractMatrix{Float64}, st)

    # TODO: Test.
    va_ = [!allequal(fl_) for fl_ in eachrow(fe_x_sa_x_fl)]

    BioLab.Matrix.apply_by_row!(fl_ -> _normalize!(fl_, st), view(fe_x_sa_x_fl, va_, :))

    return -st, st

end

function _normalize!(it, st)

    return minimum(it), maximum(it)

end

function _merge_layout(ke_va__...)

    return reduce(
        BioLab.Dict.merge,
        ke_va__;
        init = Dict(
            "width" => 800,
            "margin" => Dict("l" => 200, "r" => 200),
            "title" => Dict("x" => 0.5),
        ),
    )

end

function _merge_annotation(ke_va__...)

    return reduce(
        BioLab.Dict.merge,
        ke_va__;
        init = Dict(
            "yref" => "paper",
            "xref" => "paper",
            "yanchor" => "middle",
            "font" => Dict("size" => 10),
            "showarrow" => false,
        ),
    )

end

function _merge_annotationl(ke_va__...)

    return _merge_annotation(Dict("x" => -0.024, "xanchor" => "right"), ke_va__...)

end

function _annotate(y, ro)

    return _merge_annotationl(Dict("y" => y, "text" => "<b>$ro</b>"))

end

function _get_x(id)

    return 0.97 + id / 7

end

function _annotate(y, la, th, fe_, fe_x_st_x_nu)

    annotations = Vector{Dict{String, Any}}()

    if la

        for (id, text) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                annotations,
                _merge_annotation(
                    Dict(
                        "y" => y,
                        "x" => _get_x(id),
                        "xanchor" => "center",
                        "text" => "<b>$text</b>",
                    ),
                ),
            )

        end

    end

    y -= th

    for idy in eachindex(fe_)

        push!(
            annotations,
            _merge_annotationl(Dict("y" => y, "text" => BioLab.String.limit(fe_[idy], 24))),
        )

        sc, ma, pv, ad = (@sprintf("%.2g", nu) for nu in fe_x_st_x_nu[idy, :])

        for (idx, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                _merge_annotation(
                    Dict("y" => y, "x" => _get_x(idx), "xanchor" => "center", "text" => text),
                ),
            )

        end

        y -= th

    end

    return annotations

end

function _merge_heatmap(ke_va__...)

    return reduce(
        BioLab.Dict.merge,
        ke_va__;
        init = Dict("type" => "heatmap", "showscale" => false),
    )

end

function _color(::AbstractArray{Int})

    return BioLab.Plot.fractionate(BioLab.Plot.COPLO)

end

function _color(::AbstractArray{Float64})

    return BioLab.Plot.fractionate(BioLab.Plot.COBWR)

end

# TODO: Test.
function _get_pearson_correlation(nu1_, nu2_)

    return cor(nu1_, nu2_)

end

function make(
    fu,
    tan,
    fen,
    fe_,
    sa_,
    ta_,
    fe_x_sa_x_nu;
    pr = true,
    ic = true,
    ra = BioLab.RA,
    n_ma = 10,
    n_pv = 10,
    pl = true,
    n_ex = 8,
    st = 4.0,
    layout = Dict{String, Any}(),
    di = "",
)

    BioLab.check_print(pr, "🎎 $tan and $fen")

    # Sort samples.

    id_ = sortperm(ta_; rev = !ic)

    sa_ = sa_[id_]

    ta_ = ta_[id_]

    fe_x_sa_x_nu = fe_x_sa_x_nu[:, id_]

    # Get statistics.

    seed!(ra)

    n_fe = length(fe_)

    BioLab.check_print(pr, "💎 $(BioLab.String.count_noun(n_fe, fen)).")

    BioLab.check_print(pr, "🧮 Computing scores with $fu")

    sc_ = Vector{Float64}(undef, n_fe)

    for idf in 1:n_fe

        nu_ = fe_x_sa_x_nu[idf, :]

        sc_[idf] = fu(ta_, nu_)

    end

    if 0 < n_ma

        BioLab.check_print(
            pr,
            "🎲 Computing margin of error with $(BioLab.String.count_noun(n_ma, "sampling"))",
        )

        n_sa = length(sa_)

        id_ = 1:n_sa

        n_sm = ceil(Int, n_sa * 0.632)

        ma_ = Vector{Float64}(undef, n_fe)

        for idf in 1:n_fe

            nu_ = fe_x_sa_x_nu[idf, :]

            ra_ = Vector{Float64}(undef, n_ma)

            for idr in 1:n_ma

                ids_ = sample(id_, n_sm; replace = false)

                ra_[idr] = fu(ta_[ids_], nu_[ids_])

            end

            ma_[idf] = BioLab.Significance.get_margin_of_error(ra_)

        end

    else

        ma_ = fill(NaN, n_fe)

    end

    if 0 < n_pv

        BioLab.check_print(
            pr,
            "🎰 Computing p-values with $(BioLab.String.count_noun(n_pv, "permutation"))",
        )

        co = copy(ta_)

        ra_ = Vector{Float64}(undef, n_fe * n_pv)

        for idf in 1:n_fe

            nu_ = fe_x_sa_x_nu[idf, :]

            for idr in 1:n_pv

                ra_[(idf - 1) * n_pv + idr] = fu(shuffle!(co), nu_)

            end

        end

        pv_, ad_ = BioLab.Significance.get_p_value_and_adjust(sc_, ra_)

    else

        pv_ = ad_ = fill(NaN, n_fe)

    end

    fe_x_st_x_nu = hcat(sc_, ma_, pv_, ad_)

    ba_ = [isnan(sc) for sc in sc_]

    BioLab.check_print(pr, "💩 $(BioLab.String.count_noun(sum(ba_), "bad score")).")

    feature_x_statistic_x_humber = BioLab.DataFrame.make(
        fen,
        fe_,
        ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
        fe_x_st_x_nu,
    )

    if !isempty(di)

        BioLab.Table.write(
            joinpath(di, "feature_x_statistic_x_humber.tsv"),
            feature_x_statistic_x_humber,
        )

    end

    # TODO: Test.
    if pl

        # Select not-NaN scored to plot

        go_ = [!ba for ba in ba_]

        fep_ = fe_[go_]

        fe_x_sa_x_nup = fe_x_sa_x_nu[go_, :]

        fe_x_st_x_nup = fe_x_st_x_nu[go_, :]

        # Sort and select rows to copy and plot.

        ex_ = reverse!(BioLab.Collection.get_extreme_id(fe_x_st_x_nup[:, 1], n_ex))

        fep_ = fep_[ex_]

        fe_x_sa_x_nup = fe_x_sa_x_nup[ex_, :]

        fe_x_st_x_nup = fe_x_st_x_nup[ex_, :]

        # Cluster within groups.
        # TODO:

        # Normalize target.

        tan_ = copy(ta_)

        tai, taa = _normalize!(tan_, st)

        BioLab.check_print(pr, "🌈 $tan colors can range frm $tai to $taa.")

        # Normalize features.

        fe_x_sa_x_nupn = copy(fe_x_sa_x_nup)

        fei, fea = _normalize!(fe_x_sa_x_nupn, st)

        BioLab.check_print(pr, "🌈 $fen colors can range frm $fei to $fea.")

        # Make layout.

        n_ro = length(fep_) + 2

        th = 1 / n_ro

        th2 = th / 2

        height = max(400, 40 * n_ro)

        layout = _merge_layout(
            Dict(
                "height" => height,
                "title" => Dict("text" => "<b>$tan</b> and <b>$fen</b>"),
                "yaxis2" =>
                    Dict("domain" => (1 - th, 1.0), "dtick" => 1, "showticklabels" => false),
                "yaxis" => Dict(
                    "domain" => (0.0, 1 - th * 2),
                    "autorange" => "reversed",
                    "showticklabels" => false,
                ),
                "annotations" => vcat(
                    _annotate(1 - th2, tan),
                    _annotate(1 - th2 * 3, true, th, fep_, fe_x_st_x_nup),
                ),
            ),
            layout,
        )

        # Make traces.

        heatmapx = Dict("x" => sa_)

        data = [
            _merge_heatmap(
                heatmapx,
                Dict(
                    "yaxis" => "y2",
                    "z" => [tan_],
                    "text" => [ta_],
                    "zmin" => tai,
                    "zmax" => taa,
                    "colorscale" => _color(tan_),
                    "hoverinfo" => "x+z+text",
                ),
            ),
            _merge_heatmap(
                heatmapx,
                Dict(
                    "yaxis" => "y",
                    "y" => fep_,
                    "z" => collect(eachrow(fe_x_sa_x_nupn)),
                    "text" => collect(eachrow(fe_x_sa_x_nup)),
                    "zmin" => fei,
                    "zmax" => fea,
                    "colorscale" => _color(fe_x_sa_x_nupn),
                    "hoverinfo" => "x+y+z+text",
                ),
            ),
        ]

        # Plot, write, and return.

        if isempty(di)

            ht = ""

        else

            ht = joinpath(di, "match_panel.html")

        end

        BioLab.Plot.plot(data, layout; he = height + 80, ht)

    end

    return feature_x_statistic_x_humber

end

end
