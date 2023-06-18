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

        if !allequal(fl_)

            _normalize!(fl_, st)

        end

    end

    -st, st

end

function _normalize!(it, ::Any)

    minimum(it), maximum(it)

end

function _merge_layout(ke_va__...)

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

function _merge_annotation(ke_va__...)

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

function _merge_annotationl(ke_va__...)

    _merge_annotation(Dict("x" => -0.024, "xanchor" => "right"), ke_va__...)

end

function _annotate(y, ro)

    _merge_annotationl(Dict("y" => y, "text" => "<b>$ro</b>"))

end

function _get_x(id)

    0.97 + id / 7

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

    annotations

end

function _merge_heatmap(ke_va__...)

    reduce(BioLab.Dict.merge, ke_va__; init = Dict("type" => "heatmap", "showscale" => false))

end

function _color(nu_::AbstractArray{Int})

    if length(unique(nu_)) < 3

        co = BioLab.Plot.COBIN

    else

        co = BioLab.Plot.COPLO

    end

    BioLab.Plot.fractionate(co)

end

function _color(::AbstractArray{Float64})

    BioLab.Plot.fractionate(BioLab.Plot.COBWR)

end

function make(
    fu,
    tan,
    fen,
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
    di = "",
)

    n_fe = length(fe_)

    @info "Matching $tan and $(BioLab.String.count(n_fe, fen)) with $fu"

    id_ = sortperm(ta_; rev)

    sa_ = sa_[id_]

    ta_ = ta_[id_]

    fe_x_sa_x_nu = fe_x_sa_x_nu[:, id_]

    @info "Computing scores"

    sc_ = [fu(ta_, nu_) for nu_ in eachrow(fe_x_sa_x_nu)]

    ba_ = map(BioLab.Bad.is_bad, sc_)

    if any(ba_)

        @warn "Found $(BioLab.String.count(sum(n_ba), "bad value"))."

    end

    if 0 < n_ma

        @info "Computing margin of error with $(BioLab.String.count(n_ma, "sampling"))"

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

        @info "Computing p-values with $(BioLab.String.count(n_pv, "permutation"))"

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
        fen,
        fe_,
        ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
        fe_x_st_x_nu,
    )

    if !isempty(di)

        BioLab.Table.write(
            joinpath(di, "feature_x_statistic_x_number.tsv"),
            feature_x_statistic_x_number,
        )

    end

    if 0 < n_ex

        go_ = map(!, ba_)

        fep_ = fe_[go_]

        fe_x_sa_x_nup = fe_x_sa_x_nu[go_, :]

        fe_x_st_x_nup = fe_x_st_x_nu[go_, :]

        ex_ = reverse!(BioLab.Collection.get_extreme(fe_x_st_x_nup[:, 1], n_ex))

        fep_ = fep_[ex_]

        fe_x_sa_x_nup = fe_x_sa_x_nup[ex_, :]

        fe_x_st_x_nup = fe_x_st_x_nup[ex_, :]

        if ta_ isa AbstractVector{Int}

            @info "Clustering within groups"

            fu = BioLab.Clustering.Euclidean()

            id_ = Vector{Int}()

            for ta in unique(ta_)

                idg_ = findall(==(ta), ta_)

                or_ = BioLab.Clustering.hierarchize(fe_x_sa_x_nup[:, idg_], 2; fu).order

                append!(id_, idg_[or_])

            end

            sa_ = sa_[id_]

            ta_ = ta_[id_]

            fe_x_sa_x_nup = fe_x_sa_x_nup[:, id_]

        end

        tac_ = copy(ta_)

        tai, taa = _normalize!(tac_, st)

        @info "$tan colors can range from $tai to $taa."

        fe_x_sa_x_nupc = copy(fe_x_sa_x_nup)

        fei, fea = _normalize!(fe_x_sa_x_nupc, st)

        @info "$fen colors can range from $fei to $fea."

        n_ro = length(fep_) + 2

        th = 1 / n_ro

        th2 = th / 2

        height = max(400, 40 * n_ro)

        layout = _merge_layout(
            Dict(
                "height" => height,
                "title" => Dict("text" => fen),
                "yaxis2" =>
                    Dict("domain" => (1 - th, 1), "dtick" => 1, "showticklabels" => false),
                "yaxis" => Dict(
                    "domain" => (0, 1 - th * 2),
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

        data = [
            _merge_heatmap(
                Dict(
                    "yaxis" => "y2",
                    "x" => sa_,
                    "z" => [tac_],
                    "text" => [ta_],
                    "zmin" => tai,
                    "zmax" => taa,
                    "colorscale" => _color(tac_),
                    "hoverinfo" => "x+z+text",
                ),
            ),
            _merge_heatmap(
                Dict(
                    "yaxis" => "y",
                    "y" => fep_,
                    "x" => sa_,
                    "z" => collect(eachrow(fe_x_sa_x_nupc)),
                    "text" => collect(eachrow(fe_x_sa_x_nup)),
                    "zmin" => fei,
                    "zmax" => fea,
                    "colorscale" => _color(fe_x_sa_x_nupc),
                    "hoverinfo" => "x+y+z+text",
                ),
            ),
        ]

        if isempty(di)

            ht = ""

        else

            ht = joinpath(di, "match_panel.html")

        end

        BioLab.Plot.plot(data, layout; he = height + 80, ht)

    end

    feature_x_statistic_x_number

end

function make(tst, tsf, n_ma, n_pv, n_ex, di)

    _tan, ta_, sa_, ta_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tst))

    fen, fe_, _saf_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tsf))

    @assert sa_ == _saf_

    for (ta, nu_) in zip(ta_, eachrow(ta_x_sa_x_nu))

        go_ = map(!isnan, nu_)

        sag_ = sa_[go_]

        nug_ = nu_[go_]

        try

            nug_ = convert(Vector{Int}, nug_)

        catch

        end

        make(
            cor,
            ta,
            fen,
            fe_,
            sag_,
            nug_,
            fe_x_sa_x_nu[:, go_];
            n_ma,
            n_pv,
            n_ex,
            di = mkdir(joinpath(di, BioLab.Path.clean("$(ta)__vs__$fen"))),
        )

    end

end

function compare(ts1, ts2, di)

    fen, fe1_, st_, fe_x_st_x_nu1 = BioLab.DataFrame.separate(BioLab.Table.read(ts1))

    _fen, fe2_, _st_, fe_x_st_x_nu2 = BioLab.DataFrame.separate(BioLab.Table.read(ts2))

    @assert fen == _fen

    @assert fe1_ == fe2_

    @assert st_ == _st_

    nu1_, fe1_ = BioLab.Collection.sort_like((fe_x_st_x_nu1[:, 1], fe1_))

    id_ = indexin(fe1_, fe2_)

    fe2_ = fe2_[id_]

    nu2_ = fe_x_st_x_nu2[id_, 1]

    @assert fe1_ == fe2_

    op_ = [sqrt(nu1^2 + nu2^2) for (nu1, nu2) in zip(nu1_, nu2_)]

    BioLab.NumberArray.normalize_with_01!(op_)

    na1 = basename(dirname(ts1))

    na2 = basename(dirname(ts2))

    BioLab.Plot.plot_scatter(
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
        ht = joinpath(di, "$(na1)__vs__$na2.html"),
    )

end

end
