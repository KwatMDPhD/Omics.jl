function plot_heat_map(
    z;
    y = ["$id *" for id in 1:size(z, 1)],
    x = ["* $id" for id in 1:size(z, 2)],
    na1 = "Row",
    na2 = "Column",
    gr1_ = [],
    gr2_ = [],
    layout = Dict(),
    ou = "",
)

    si1, si2 = size(z)

    axis = Dict("domain" => [0.0, 0.95], "automargin" => true)

    axis2 = Dict("domain" => [0.96, 1.0], "tickvals" => [])

    layout = OnePiece.dict.merge(
        Dict(
            "title" => Dict("text" => "Heat Map"),
            "yaxis" =>
                OnePiece.dict.merge(axis, Dict("title" => Dict("text" => "$na1 (n=$si1)"))),
            "xaxis" =>
                OnePiece.dict.merge(axis, Dict("title" => Dict("text" => "$na2 (n=$si2)"))),
            "yaxis2" => axis2,
            "xaxis2" => axis2,
        ),
        layout,
    )

    data = []

    # TODO: cluster within a group

    if !isempty(gr1_)

        so_ = sortperm(gr1_)

        gr1_ = gr1_[so_]

        y = y[so_]

        z = z[so_, :]

    end

    if !isempty(gr2_)

        so_ = sortperm(gr2_)

        gr2_ = gr2_[so_]

        x = x[so_]

        z = z[:, so_]

    end

    fl_ = si1:-1:1

    push!(
        data,
        Dict(
            "type" => "heatmap",
            "z" => collect(eachrow(z))[fl_],
            "y" => y[fl_],
            "x" => x,
            "colorscale" => "Picnic",
            "colorbar" => Dict("x" => 1.05),
        ),
    )

    tr = Dict(
        "type" => "heatmap",
        "colorscale" => "Rainbow",
        "colorbar" => Dict("x" => 1.15, "dtick" => 1),
    )

    if !isempty(gr1_)

        push!(
            data,
            OnePiece.dict.merge(
                tr,
                Dict("xaxis" => "x2", "z" => [[gr] for gr in gr1_][fl_], "hoverinfo" => "z+y"),
            ),
        )

    end

    if !isempty(gr2_)

        push!(
            data,
            OnePiece.dict.merge(tr, Dict("yaxis" => "y2", "z" => [gr2_], "hoverinfo" => "z+x")),
        )

    end

    plot(data, layout, ou = ou)

end
