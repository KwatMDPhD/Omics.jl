module Match

using Printf: @sprintf

using Random: shuffle!

using Statistics: cor

using StatsBase: sample

using ..BioLab

function _normalize!(fl_::AbstractVector{Float64}, st)

    BioLab.NumberArray.normalize_with_0!(fl_)

    clamp!(fl_, -st, st)

    -st, st

end

function _normalize!(fe_x_sa_x_fl::AbstractMatrix{Float64}, st)

    for fl_ in eachrow(fe_x_sa_x_fl)

        if allequal(fl_)

            @warn "All numbers are equal."

        else

            _normalize!(fl_, st)

        end

    end

    -st, st

end

function _normalize!(it, ::Any)

    minimum(it), maximum(it)

end

function _make_heatmap(ke_va__...)

    reduce(BioLab.Dict.merge, ke_va__; init = Dict("type" => "heatmap", "showscale" => false))

end

function _color(it_::AbstractArray{Int})

    if length(unique(it_)) < 3

        co = BioLab.Plot.COBIN

    else

        co = BioLab.Plot.COPLO

    end

    BioLab.Plot.fractionate(co)

end

function _color(::AbstractArray{Float64})

    BioLab.Plot.fractionate(BioLab.Plot.COBWR)

end

function _make_layout(ke_va__...)

    reduce(
        BioLab.Dict.merge,
        ke_va__;
        init = Dict(
            "margin" => Dict("l" => 200, "r" => 200),
            "width" => 800,
            "title" => Dict("x" => 0.5),
        ),
    )

end

function _make_annotation(ke_va__...)

    reduce(
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

function _make_annotationl(ke_va__...)

    _make_annotation(Dict("x" => -0.024, "xanchor" => "right"), ke_va__...)

end

function _annotate(y, ro)

    _make_annotationl(Dict("y" => y, "text" => "<b>$ro</b>"))

end

function _get_x(id)

    0.97 + id / 7

end

function _annotate(y, la, th, fe_, fe_x_st_x_nu)

    annotations = Vector{Dict{String, Any}}()

    if la

        for (idx, text) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                annotations,
                _make_annotation(
                    Dict(
                        "y" => y,
                        "x" => _get_x(idx),
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
            _make_annotationl(Dict("y" => y, "text" => BioLab.String.limit(fe_[idy], 24))),
        )

        sc, ma, pv, ad = (@sprintf("%.2g", nu) for nu in fe_x_st_x_nu[idy, :])

        for (idx, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                _make_annotation(
                    Dict("y" => y, "x" => _get_x(idx), "xanchor" => "center", "text" => text),
                ),
            )

        end

        y -= th

    end

    annotations

end

function _order_sample(id_, sa_, ta_, fe_x_sa_x_nu)

    sa_[id_], ta_[id_], fe_x_sa_x_nu[:, id_]

end

function _plot(ht, nat, naf, fep_, sa_, ta_, fe_x_sa_x_nu, fe_x_st_x_nu, st, layout)

    if ta_ isa AbstractVector{Int}

        @info "Clustering within groups"

        fu = BioLab.Clustering.Euclidean()

        id_ = Vector{Int}()

        for ta in unique(ta_)

            idg_ = findall(==(ta), ta_)

            append!(id_, idg_[BioLab.Clustering.hierarchize(fe_x_sa_x_nu[:, idg_], 2; fu).order])

        end

        sa_, ta_, fe_x_sa_x_nu = _order_sample(id_, sa_, ta_, fe_x_sa_x_nu)

    end

    tan_ = copy(ta_)

    tai, taa = _normalize!(tan_, st)

    @info "$nat colors can range from $tai to $taa."

    fe_x_sa_x_nun = copy(fe_x_sa_x_nu)

    fei, fea = _normalize!(fe_x_sa_x_nun, st)

    @info "$naf colors can range from $fei to $fea."

    n_ro = length(fep_) + 2

    th = 1 / n_ro

    th2 = th / 2

    height = max(400, 40 * n_ro)

    BioLab.Plot.plot(
        ht,
        [
            _make_heatmap(
                Dict(
                    "yaxis" => "y2",
                    "x" => sa_,
                    "z" => [tan_],
                    "text" => [ta_],
                    "zmin" => tai,
                    "zmax" => taa,
                    "colorscale" => _color(tan_),
                    "hoverinfo" => "x+z+text",
                ),
            ),
            _make_heatmap(
                Dict(
                    "yaxis" => "y",
                    "y" => fep_,
                    "x" => sa_,
                    "z" => collect(eachrow(fe_x_sa_x_nun)),
                    "text" => collect(eachrow(fe_x_sa_x_nu)),
                    "zmin" => fei,
                    "zmax" => fea,
                    "colorscale" => _color(fe_x_sa_x_nun),
                    "hoverinfo" => "x+y+z+text",
                ),
            ),
        ],
        _make_layout(
            Dict(
                "height" => height,
                "title" => Dict("text" => naf),
                "yaxis2" => Dict("domain" => (1 - th, 1), "dtick" => 1, "showticklabels" => false),
                "yaxis" => Dict(
                    "domain" => (0, 1 - th * 2),
                    "autorange" => "reversed",
                    "showticklabels" => false,
                ),
                "annotations" => vcat(
                    _annotate(1 - th2, nat),
                    _annotate(1 - th2 * 3, true, th, fep_, fe_x_st_x_nu),
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

    BioLab.Path.error_missing(di)

    pr = joinpath(di, "feature_x_statistic_x_number")

    n_fe = length(fe_)

    n_no = BioLab.String.count(n_fe, naf)

    @info "Matching $nat and $n_no with $fu"

    sa_, ta_, fe_x_sa_x_nu = _order_sample(sortperm(ta_; rev), sa_, ta_, fe_x_sa_x_nu)

    @info "Computing scores"

    sc_ = map(nu_ -> fu(ta_, nu_), eachrow(fe_x_sa_x_nu))

    ba_ = map(BioLab.Bad.is_bad, sc_)

    if any(ba_)

        n_no = BioLab.String.count(sum(n_ba), "bad value")

        @warn "Found $n_no."

    end

    if 0 < n_ma

        n_no = BioLab.String.count(n_ma, "sampling")

        @info "Computing margin of error with $n_no"

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

        n_no = BioLab.String.count(n_pv, "permutation")

        @info "Computing p-values with $n_no"

        co = copy(ta_)

        ra_ = Vector{Float64}(undef, n_fe * n_pv)

        for idf in 1:n_fe

            nu_ = fe_x_sa_x_nu[idf, :]

            for idr in 1:n_pv

                ra_[(idf - 1) * n_pv + idr] = fu(shuffle!(co), nu_)

            end

        end

        pv_, ad_ = BioLab.Significance.get_p_value_adjust(sc_, ra_)

    else

        pv_ = ad_ = fill(NaN, n_fe)

    end

    fe_x_st_x_nu = hcat(sc_, ma_, pv_, ad_)

    feature_x_statistic_x_number = BioLab.DataFrame.make(
        naf,
        fe_,
        ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
        fe_x_st_x_nu,
    )

    ts = "$pr.tsv"

    BioLab.Path.warn_overwrite(ts)

    BioLab.Table.write(ts, feature_x_statistic_x_number)

    if 0 < n_ex

        id_ = reverse!(BioLab.Vector.get_extreme(fe_x_st_x_nu[:, 1], n_ex))

        _plot(
            "$pr.html",
            nat,
            naf,
            fe_[id_],
            sa_,
            ta_,
            fe_x_sa_x_nu[id_, :],
            fe_x_st_x_nu[id_, :],
            st,
            layout,
        )

    end

    feature_x_statistic_x_number

end

# TODO: Test.
function make(di, tst, tsf, n_ma, n_pv, n_ex, st)

    BioLab.Path.error_missing(di)

    _na, nat_, sa_, ta_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tst))

    naf, fe_, _saf_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tsf))

    if sa_ != _saf_

        error("Samples differ.")

    end

    for (nat, ta_) in zip(nat_, eachrow(ta_x_sa_x_nu))

        sag_, tag_, fe_x_sa_x_nug = _order_sample(map(!isnan, ta_), sa_, ta_, fe_x_sa_x_nu)

        try

            tag_ = convert(Vector{Int}, tag_)

        catch

        end

        di2 = joinpath(di, BioLab.Path.clean("$(naf)_matching_$naf"))

        if !isdir(di2)

            mkdir(di2)

        end

        make(di2, cor, nat, naf, fe_, sag_, tag_, fe_x_sa_x_nug; n_ma, n_pv, n_ex, st)

    end

end

# TODO: Test.
function compare(di, na1, na2, ts1, ts2)

    BioLab.Path.error_missing(di)

    _naf1, fe1_, st1_, fe_x_st_x_nu1 = BioLab.DataFrame.separate(BioLab.Table.read(ts1))

    _naf2, fe2_, st2_, fe_x_st_x_nu2 = BioLab.DataFrame.separate(BioLab.Table.read(ts2))

    if fe1_ != fe2_

        error("Features differ.")

    end

    if st1_ != st2_

        error("Statistics differ.")

    end

    nu1_, fe1_ = BioLab.Vector.sort_like((fe_x_st_x_nu1[:, 1], fe1_))

    id_ = indexin(fe1_, fe2_)

    fe2_ = fe2_[id_]

    nu2_ = fe_x_st_x_nu2[id_, 1]

    op_ = map((nu1, nu2) -> sqrt(nu1^2 + nu2^2), zip(nu1_, nu2_))

    BioLab.NumberArray.normalize_with_01!(op_)

    BioLab.Plot.plot_scatter(
        joinpath(di, "$(na1)_and_$na2.html"),
        (nu2_,),
        (nu1_,),
        (fe1_,),
        mode_ = ("markers",),
        marker_color_ = ("#20d9ba",);
        opacity_ = (op_,),
        layout = Dict(
            "title" => Dict("text" => "Comparing Match"),
            "yaxis" => Dict("title" => Dict("text" => na2)),
            "xaxis" => Dict("title" => Dict("text" => na1)),
        ),
    )

end

end
