module Match

using Printf: @sprintf

using ..BioLab

function _normalize!(fl_::AbstractVector{Float64}, st)

    BioLab.Normalization.normalize_with_0!(fl_)

    clamp!(fl_, -st, st)

    return -st, st

end

function _normalize!(fe_x_sa_x_fl::AbstractMatrix{Float64}, st)

    BioLab.Matrix.apply_by_row!(fe_x_sa_x_fl, (fl_) -> _normalize!(fl_, st))

    return -st, st

end

function _normalize!(it, st)

    return minimum(it), maximum(it)

end

# TODO: Add to `Dict`.
function _merge(ke1_va1, ke2_va2)

    return BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!)

end

function _merge_layout(ke_va__...)

    return reduce(
        _merge,
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
        _merge,
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

function _annotate(y, la, he, fe_, fe_x_st_x_nu)

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

    y -= he

    for idy in eachindex(fe_)

        push!(
            annotations,
            _merge_annotationl(Dict("y" => y, "text" => BioLab.String.limit(fe_[idy], 24))),
        )

        sc, ma, pv, ad = (@sprintf("%.2f", nu) for nu in fe_x_st_x_nu[idy, :])

        for (idx, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                _merge_annotation(
                    Dict("y" => y, "x" => _get_x(idx), "xanchor" => "center", "text" => text),
                ),
            )

        end

        y -= he

    end

    return annotations

end

function _merge_heatmap(ke_va__...)

    return reduce(_merge, ke_va__; init = Dict("type" => "heatmap", "showscale" => false))

end

function _color(::AbstractArray{Int})

    return BioLab.Plot.fractionate(BioLab.Plot.COPLO)

end

function _color(::AbstractArray{Float64})

    return BioLab.Plot.fractionate(BioLab.Plot.COPLA)

end

function make(
    # Target.
    tan,
    sa1_,
    ta_,
    # Features.
    fen,
    fe_,
    #sa2_,
    fe_x_sa_x_nu,
    # Function.
    fu;
    # Keyword arguments.
    ic = true,
    n_ex = 8,
    st = 4.0,
    layout = Dict{String, Any}(),
    ht = "",
)

    # Sort samples.

    id_ = sortperm(ta_; rev = !ic)

    sa1_ = sa1_[id_]

    ta_ = ta_[id_]

    fe_x_sa_x_nu = fe_x_sa_x_nu[:, id_]

    # Get statistics.
    # TODO:

    fe_x_st_x_nu = fu

    # Sort and select rows to copy and plot.

    id_ = reverse!(BioLab.Collection.get_extreme_id(fe_x_st_x_nu[:, 1], n_ex))

    fep_ = fe_[id_]

    fe_x_sa_x_nup = fe_x_sa_x_nu[id_, :]

    fe_x_st_x_nup = fe_x_st_x_nu[id_, :]

    # Normalize target.

    tan_ = copy(ta_)

    tai, taa = _normalize!(tan_, st)

    println("🌈 $tan colors can range frm $tai to $taa.")

    # Normalize features.

    fe_x_sa_x_nupn = copy(fe_x_sa_x_nup)

    fei, fea = _normalize!(fe_x_sa_x_nupn, st)

    println("🌈 $fen colors can range frm $fei to $fea.")

    # Cluster within groups.
    # TODO:

    # Make layout.

    n_ro = length(fep_) + 2

    he = 1 / n_ro

    he2 = he / 2

    layout = _merge_layout(
        Dict(
            "height" => max(400, 40 * n_ro),
            "title" => Dict("text" => "Match Panel"),
            "yaxis2" =>
                Dict("domain" => (1 - he, 1.0), "showticklabels" => false, "tickvals" => ()),
            "yaxis" => Dict(
                "domain" => (0.0, 1 - he * 2),
                "showticklabels" => false,
                "tickvals" => (),
            ),
            "annotations" => vcat(
                _annotate(1 - he2, tan),
                _annotate(1 - he2 * 3, true, he, fep_, fe_x_st_x_nup),
            ),
        ),
        layout,
    )

    # Make traces.

    heatmapx = Dict("x" => sa1_)

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

    # Plot and return.

    BioLab.Plot.plot(data, layout; ht)

    return BioLab.DataFrame.make(
        fen,
        fe_,
        ["Score", "Margin of Error", "P-Value", "Adjusted P-Value"],
        fe_x_st_x_nu,
    )

end

end
