module Match

using Printf: @sprintf

using ..BioLab

function _merge_for_reduce(ke1_va1, ke2_va2)

    return BioLab.Dict.merge(ke1_va1, ke2_va2, BioLab.Dict.set_with_last!)

end

function _reduce(ke_va, ke_va__...)

    if isempty(ke_va__)

        return ke_va

    else

        return reduce(_merge_for_reduce, ke_va__; init = ke_va)

    end

end

function _merge_layout(ke_va__...)

    return _reduce(
        Dict(
            "width" => 800,
            "margin" => Dict("l" => 200, "r" => 200),
            "title" => Dict("x" => 0.5),
        ),
        ke_va__...,
    )

end

function _merge_annotation(ke_va__...)

    return _reduce(
        Dict(
            "yref" => "paper",
            "xref" => "paper",
            "yanchor" => "middle",
            "font" => Dict("size" => 10),
            "showarrow" => false,
        ),
        ke_va__...,
    )

end

function _merge_annotationl(ke_va__...)

    return _merge_annotation(Dict("x" => -0.024, "xanchor" => "right"), ke_va__...)

end

function _merge_heatmap(ke_va__...)

    return _reduce(Dict("type" => "heatmap", "showscale" => false), ke_va__...)

end

function _make_target_annotation(y, ro)

    return _merge_annotationl(Dict("y" => y, "text" => "<b>$ro</b>"))

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

    for idy in eachindex(ro_)

        push!(
            annotations,
            _merge_annotationl(Dict("y" => y, "text" => BioLab.String.limit(ro_[idy], 16))),
        )

        sc, ma, pv, ad = st[idy, :]

        sc = @sprintf("%.2f", sc)

        ma = @sprintf("%.2f", ma)

        pv = @sprintf("%.2f", pv)

        ad = @sprintf("%.2f", ad)

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

function make(nat, co_, ta, ro_, da, st; ic = false, layout = Dict{String, Any}(), ht = "")

    # Sort target and data columns.

    id_ = sortperm(ta; rev = !ic)

    co_ = co_[id_]

    ta = ta[id_]

    da = da[:, id_]

    # Get statistics.

    # Sort statistics.

    # Select rows to plot.

    tap = copy(ta)

    dap = copy(da)

    stp = copy(st)

    sortperm(stp[:, 1])

    # Process target.

    mit = 10

    mat = 20

    # Process data.

    mid = 10

    mad = 20

    # Cluster within a group.

    # Plot

    n_ro, n_co = size(da)

    n_ro += 2

    he = 1 / n_ro

    he2 = he / 2

    layout = _merge_layout(
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
                _make_data_annotation(1 - he2 * 3, true, he, ro_, stp),
            ),
        ),
        layout,
    )

    heatmapx = Dict("x" => co_)

    data = [
        _merge_heatmap(
            heatmapx,
            Dict(
                "yaxis" => "y2",
                "z" => [tap],
                "text" => [ta],
                "zmin" => mit,
                "zmax" => mat,
                "colorscale" => BioLab.Plot.fractionate(BioLab.Plot.COPLA),
                "hoverinfo" => "x+z+text",
            ),
        ),
        _merge_heatmap(
            heatmapx,
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
        ),
    ]

    BioLab.Plot.plot(data, layout; ht)

    return nothing

end

end
