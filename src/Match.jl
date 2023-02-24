module Match

using Printf: @sprintf

using ..BioLab

LAYOUT =
    Dict("width" => 800, "margin" => Dict("l" => 200, "r" => 200), "title" => Dict("x" => 0.5))

ANNOTATION = Dict(
    "yref" => "paper",
    "xref" => "paper",
    "yanchor" => "middle",
    "font" => Dict("size" => 10),
    "showarrow" => false,
)

ANNOTATIONL = BioLab.Dict.merge(
    ANNOTATION,
    Dict("x" => -0.024, "xanchor" => "right"),
    BioLab.Dict.set_with_last!,
)

HEATMAP = Dict("type" => "heatmap", "showscale" => false)

function _make_target_annotation(y, ro)

    return BioLab.Dict.merge(
        ANNOTATIONL,
        Dict("y" => y, "text" => "<b>$ro</b>"),
        BioLab.Dict.set_with_last!,
    )

end

function _get_x(id)

    return 0.97 + id / 7

end

function _make_data_annotation(y, la, he, ro_, st)

    annotations = Vector{Dict{String, Any}}()

    if la

        for (id, text) in enumerate(("Sc (⧳)", "Pv", "Ad"))

            push!(
                annotations,
                BioLab.Dict.merge(
                    ANNOTATION,
                    Dict(
                        "y" => y,
                        "x" => _get_x(id),
                        "xanchor" => "center",
                        "text" => "<b>$text</b>",
                    ),
                    BioLab.Dict.set_with_last!,
                ),
            )

        end

    end

    y -= he

    for idy in 1:length(ro_)

        push!(
            annotations,
            BioLab.Dict.merge(
                ANNOTATIONL,
                Dict("y" => y, "text" => BioLab.String.limit(ro_[idy], 16)),
                BioLab.Dict.set_with_last!,
            ),
        )

        sc, ma, pv, ad = st[idy, :]

        sc = @sprintf("%.2f", sc)

        ma = @sprintf("%.2f", ma)

        pv = @sprintf("%.2f", pv)

        ad = @sprintf("%.2f", ad)

        for (idx, text) in enumerate(("$sc ($ma)", pv, ad))

            push!(
                annotations,
                BioLab.Dict.merge(
                    ANNOTATION,
                    Dict("y" => y, "x" => _get_x(idx), "xanchor" => "center", "text" => text),
                    BioLab.Dict.set_with_last!,
                ),
            )

        end

        y -= he

    end

    return annotations

end

function make(nat, co_, ta, ro_, da, st; ht = "")

    # Sort target and data columns.

    # Get statistics.

    # Sort statistics.

    # Select rows to plot.

    # Process target.

    tap = ta * 10

    mit = 10

    mat = 20

    # Process data.

    dap = da * 10

    mid = 10

    mad = 20

    # Cluster within a group.

    n_ro, n_co = size(da)

    n_ro += 2

    he = 1 / n_ro

    he2 = he / 2

    layout = BioLab.Dict.merge(
        LAYOUT,
        Dict(
            "height" => max(640, 24 * n_ro),
            "title" => Dict("text" => "Match Panel"),
            "yaxis2" =>
                Dict("domain" => (1 - he, 1.0), "showticklabels" => false, "tickvals" => ()),
            "yaxis" => Dict(
                "domain" => (0.0, 1 - he * 2),
                "showticklabels" => false,
                "tickvals" => (),
            ),
            "annotations" => vcat(
                _make_target_annotation(1 - he2, nat),
                _make_data_annotation(1 - he2 * 3, true, he, ro_, st),
            ),
        ),
        BioLab.Dict.set_with_last!,
    )

    HEATMAP["x"] = co_

    data = [
        BioLab.Dict.merge(
            HEATMAP,
            Dict(
                "yaxis" => "y2",
                "z" => [tap],
                "text" => [ta],
                "zmin" => mit,
                "zmax" => mat,
                "colorscale" => BioLab.Plot.fractionate(BioLab.Plot.COPLA),
                "hoverinfo" => "x+z+text",
            ),
            BioLab.Dict.set_with_last!,
        ),
        BioLab.Dict.merge(
            HEATMAP,
            Dict(
                "yaxis" => "y",
                "y" => ro_,
                "z" => collect(eachrow(dap)),
                "text" => collect(eachrow(da)),
                "zmin" => mid,
                "zmax" => mad,
                "colorscale" => BioLab.Plot.fractionate(BioLab.Plot.COPLA),
                "hoverinfo" => "x+y+z+text",
            ),
            BioLab.Dict.set_with_last!,
        ),
    ]

    BioLab.Plot.plot(data, layout; ht)

    return nothing

end

end
