module Match

using Printf: @sprintf

using ProgressMeter: @showprogress

using Random: shuffle!

using Statistics: cor

using StatsBase: sample

using BioLab

function _order_sample(id_, sa_, ta_, fe_x_sa_x_nu)

    view(sa_, id_), view(ta_, id_), view(fe_x_sa_x_nu, :, id_)

end

function _align!(fl_::AbstractVector{Float64}, st::Real)

    BioLab.Normalization.normalize_with_0!(fl_)

    clamp!(fl_, -st, st)

    -st, st

end

function _align!(fe_x_sa_x_fl::AbstractMatrix{Float64}, st::Real)

    for fl_ in eachrow(fe_x_sa_x_fl)

        if allequal(fl_)

            @warn "All numbers are equal."

        else

            _align!(fl_, st)

        end

    end

    -st, st

end

function _align!(it::AbstractArray{Int}, ::Real)

    minimum(it), maximum(it)

end

const _ANNOTATION =
    Dict("yref" => "paper", "xref" => "paper", "showarrow" => false, "yanchor" => "middle")

const _ANNOTATIONL = BioLab.Dict.merge_recursively(
    _ANNOTATION,
    Dict(
        "x" => -0.024,
        "xanchor" => "right",
        "font" => Dict("family" => "Gravitas One", "size" => 16),
    ),
)

function _get_x(id)

    0.97 + id * 0.088

end

function _annotate_feature(y, la, th, fe_, n_li, fe_x_st_x_nu)

    annotations = Vector{Dict{String, Any}}()

    if la

        for (idx, text) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                annotations,
                BioLab.Dict.merge_recursively(
                    _ANNOTATION,
                    Dict(
                        "y" => y,
                        "x" => _get_x(idx),
                        "xanchor" => "center",
                        "text" => "<b>$text</b>",
                        "font" => Dict("family" => "Droid Serif", "size" => 16),
                    ),
                ),
            )

        end

    end

    y -= th

    for idy in eachindex(fe_)

        push!(
            annotations,
            BioLab.Dict.merge_recursively(
                _ANNOTATIONL,
                Dict("y" => y, "text" => BioLab.String.limit(fe_[idy], n_li)),
            ),
        )

        sc, ma, pv, ad = (@sprintf("%.2g", nu) for nu in view(fe_x_st_x_nu, idy, :))

        for (idx, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                BioLab.Dict.merge_recursively(
                    _ANNOTATION,
                    Dict(
                        "y" => y,
                        "x" => _get_x(idx),
                        "xanchor" => "center",
                        "text" => text,
                        "font" => Dict("family" => "Droid Serif", "size" => 12.8),
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

        fu = BioLab.Clustering.Euclidean()

        id_ = Vector{Int}()

        for ta in unique(ta_)

            idg_ = findall(==(ta), ta_)

            append!(
                id_,
                idg_[BioLab.Clustering.hierarchize(view(fe_x_sa_x_nu, :, idg_), 2; fu).order],
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

    heatmap = Dict("type" => "heatmap", "showscale" => false)

    n_ro = length(fe_) + 2

    th = 1 / n_ro

    th2 = th / 2

    height = max(640, 40 * n_ro)

    n_sa = length(sa_)

    n_li = 30

    natl = BioLab.String.limit(nat, n_li)


    BioLab.Plot.plot(
        ht,
        [
            BioLab.Dict.merge_recursively(
                heatmap,
                Dict(
                    "yaxis" => "y2",
                    "name" => "Target",
                    "x" => sa_,
                    "z" => [tac_],
                    "text" => [ta_],
                    "zmin" => tai,
                    "zmax" => taa,
                    "colorscale" =>
                        BioLab.Plot.map_fraction_to_color(BioLab.Plot.pick_color_scheme(tac_)),
                    "hoverinfo" => "x+z+text+name",
                ),
            ),
            BioLab.Dict.merge_recursively(
                heatmap,
                Dict(
                    "name" => "Feature",
                    "y" => fe_,
                    "x" => sa_,
                    "z" => collect(eachrow(fe_x_sa_x_nuc)),
                    "text" => collect(eachrow(fe_x_sa_x_nu)),
                    "zmin" => fei,
                    "zmax" => fea,
                    "colorscale" => BioLab.Plot.map_fraction_to_color(
                        BioLab.Plot.pick_color_scheme(fe_x_sa_x_nuc),
                    ),
                ),
            ),
        ],
        BioLab.Dict.merge_recursively(
            Dict(
                "margin" => Dict("l" => 220, "r" => 220),
                "height" => height,
                "width" => 1200,
                "title" => Dict("text" => naf),
                "yaxis2" => Dict("domain" => (1 - th, 1), "dtick" => 1, "showticklabels" => false),
                "yaxis" => Dict(
                    "domain" => (0, 1 - th * 2),
                    "autorange" => "reversed",
                    "showticklabels" => false,
                ),
                "xaxis" => BioLab.Dict.merge_recursively(
                    BioLab.Plot.AXIS,
                    Dict("title" => Dict("text" => BioLab.String.count(n_sa, nas))),
                ),
                "annotations" => vcat(
                    BioLab.Dict.merge_recursively(
                        _ANNOTATIONL,
                        Dict("y" => 1 - th2, "text" => "<b>$natl</b>"),
                    ),
                    _annotate_feature(1 - th2 * 3, true, th, fe_, n_li, fe_x_st_x_nu),
                ),
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
    rev = false,
    n_ma = 10,
    n_pv = 10,
    n_ex = 8,
    st = 4,
    layout = Dict{String, Any}(),
)

    BioLab.Error.error_missing(di)

    pr = joinpath(di, "feature_x_statistic_x_number")

    n_fe, n_sa = size(fe_x_sa_x_nu)

    n_no = BioLab.String.count(n_fe, naf)

    @info "Matching $nat and $n_no with $fu"

    sa_, ta_, fe_x_sa_x_nu = _order_sample(sortperm(ta_; rev), sa_, ta_, fe_x_sa_x_nu)

    @info "Computing scores"

    sc_ = (nu_ -> fu(ta_, nu_)).(eachrow(fe_x_sa_x_nu))

    isb_ = isnan.(sc_)

    if any(isb_)

        n_no = BioLab.String.count(sum(isb_), "bad value")

        @warn "Found $n_no."

    end

    ma_ = fill(NaN, n_fe)

    pv_ = fill(NaN, n_fe)

    ad_ = fill(NaN, n_fe)

    if 0 < n_ma

        n_no = BioLab.String.count(n_ma, "sampling")

        @info "Computing margin of error with $n_no"

        n_sm = ceil(Int, n_sa * 0.632)

        @showprogress for idf in 1:n_fe

            ra_ = Vector{Float64}(undef, n_ma)

            nu_ = view(fe_x_sa_x_nu, idf, :)

            for idr in 1:n_ma

                ids_ = sample(1:n_sa, n_sm; replace = false)

                ra_[idr] = fu(view(ta_, ids_), view(nu_, ids_))

            end

            ma_[idf] = BioLab.Significance.get_margin_of_error(ra_)

        end

    end

    if 0 < n_pv

        n_no = BioLab.String.count(n_pv, "permutation")

        @info "Computing p-values with $n_no"

        co = copy(ta_)

        ra_ = Vector{Float64}(undef, n_fe * n_pv)

        idr = 0

        @showprogress for idf in 1:n_fe

            nu_ = view(fe_x_sa_x_nu, idf, :)

            for _ in 1:n_pv

                ra_[idr += 1] = fu(shuffle!(co), nu_)

            end

        end

        pv_, ad_ = BioLab.Significance.get_p_value_adjust(sc_, ra_)

    end

    fe_x_st_x_nu = hcat(sc_, ma_, pv_, ad_)

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

## TODO: Test di = "".
#function make(di, tst, tsf, nas, pe_; ke_ar...)
#
#    BioLab.Error.error_missing(di)
#
#    _na, nat_, sa_, ta_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.DataFrame.read(tst))
#
#    naf, fe_, saf_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.DataFrame.read(tsf))
#
#    if sa_ != saf_
#
#        error("Samples differ.")
#
#    end
#
#    for (nat, ta_) in zip(nat_, eachrow(ta_x_sa_x_nu))
#
#        sag_, tag_, fe_x_sag_x_nu = _order_sample(map(!isnan, ta_), sa_, ta_, fe_x_sa_x_nu)
#
#        try
#
#            tag_ = convert(Vector{Int}, tag_)
#
#        catch
#
#        end
#
#        di2 = mkdir(joinpath(di, BioLab.Path.clean("$(nat)_matching_$naf")))
#
#        fe_x_st_x_nu = make(di2, cor, nat, naf, fe_, nas, sag_, tag_, fe_x_sag_x_nu; ke_ar...)
#
#        is_ = BioLab.Dict.is_in(fe_, pe_)
#
#        id_ = sortperm(fe_x_st_x_nu[is_, 1]; rev = true)
#
#        _plot(
#            joinpath(di2, "peek.html"),
#            nat,
#            naf,
#            nas,
#            fe_[is_][id_],
#            sag_,
#            tag_,
#            fe_x_sag_x_nu[is_, :][id_, :],
#            fe_x_st_x_nu[is_, :][id_, :],
#            get(ke_ar, :st, 4),
#            Dict{String, Any}("title" => Dict("text" => "Peek")),
#        )
#
#    end
#
#end
#
## TODO: Test di = "".
#function compare(di, na1, na2, ts1, ts2; title_text = "")
#
#    BioLab.Error.error_missing(di)
#
#    na1c = BioLab.Path.clean(na1)
#
#    na2c = BioLab.Path.clean(na2)
#
#    pr = joinpath(di, "$(na1c)_compared_to_$na2c")
#
#    naf1, fe1_, st1_, fe_x_st_x_nu1 = BioLab.DataFrame.separate(BioLab.DataFrame.read(ts1))
#
#    naf2, fe2_, st2_, fe_x_st_x_nu2 = BioLab.DataFrame.separate(BioLab.DataFrame.read(ts2))
#
#    if naf1 != naf2
#
#        error("Feature names differ.")
#
#    end
#
#    if fe1_ != fe2_
#
#        error("Features differ.")
#
#    end
#
#    if st1_ != st2_
#
#        error("Statistics differ.")
#
#    end
#
#    nu1_ = fe_x_st_x_nu1[:, 1]
#
#    nu2_ = fe_x_st_x_nu2[:, 1]
#
#    # TODO: ..
#    go_ = map((nu1, nu2) -> !isnan(nu1) && !isnan(nu2), nu1_, nu2_)
#
#    fe1_ = fe1_[go_]
#
#    fe2_ = fe2_[go_]
#
#    nu1_ = nu1_[go_]
#
#    nu2_ = nu2_[go_]
#
#    nu1_, fe1_ = BioLab.Vector.sort_like((nu1_, fe1_))
#
#    id_ = indexin(fe1_, fe2_)
#
#    fe2_ = fe2_[id_]
#
#    nu2_ = nu2_[id_]
#
#    # TODO: ..
#    di_ = map((nu1, nu2) -> sqrt(nu1^2 + nu2^2), nu1_, nu2_)
#
#    BioLab.DataFrame.write("$pr.tsv", DataFrame(naf1 => fe1_, "Distance" => di_))
#
#    BioLab.Normalization.normalize_with_01!(di_)
#
#    BioLab.Plot.plot_scatter(
#        "$pr.html",
#        (nu2_,),
#        (nu1_,);
#        text_ = (fe1_,),
#        mode_ = ("markers",),
#        marker_color_ = (BioLab.Plot.color(di_, BioLab.Plot.COPL3),),
#        opacity_ = (di_,),
#        layout = Dict(
#            "title" => Dict("text" => title_text),
#            "yaxis" => BioLab.Dict.merge_recursively(
#                BioLab.Plot.AXIS,
#                Dict("title" => Dict("text" => na2)),
#            ),
#            "xaxis" => BioLab.Dict.merge_recursively(
#                BioLab.Plot.AXIS,
#                Dict("title" => Dict("text" => na1)),
#            ),
#        ),
#    )
#
#end
#
end
