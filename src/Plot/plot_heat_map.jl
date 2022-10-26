function plot_heat_map(
    z,
    y = ["$id *" for id in 1:size(z, 1)],
    x = ["* $id" for id in 1:size(z, 2)];
    nar = "Row",
    nac = "Column",
    colorscale = NA_CA["Plasma"],
    grr_ = [],
    grc_ = [],
    layout = Dict(),
    ht = "",
)

    si1, si2 = size(z)

    axis = Dict("domain" => [0.0, 0.95], "automargin" => true)

    axis2 = Dict("domain" => [0.96, 1.0], "tickvals" => [])

    layout = OnePiece.Dict.merge(
        Dict(
            "title" => Dict("text" => "Heat Map"),
            "yaxis" =>
                OnePiece.Dict.merge(axis, Dict("title" => Dict("text" => "$nar (n=$si1)"))),
            "xaxis" =>
                OnePiece.Dict.merge(axis, Dict("title" => Dict("text" => "$nac (n=$si2)"))),
            "yaxis2" => axis2,
            "xaxis2" => axis2,
        ),
        layout,
    )

    data = []

    # TODO: cluster within a group

    if !isempty(grr_)

        if eltype(grr_) <: AbstractString

            gr_id = OnePiece.vector.map_index(unique(grr_))[1]

            grr_ = [gr_id[gr] for gr in grr_]

        end

        so_ = sortperm(grr_)

        grr_ = grr_[so_]

        y = y[so_]

        z = z[so_, :]

    end

    if !isempty(grc_)

        if eltype(grc_) <: AbstractString

            gr_id = OnePiece.vector.map_index(unique(grc_))[1]

            grc_ = [gr_id[gr] for gr in grc_]

        end

        so_ = sortperm(grc_)

        grc_ = grc_[so_]

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
            "colorscale" => colorscale,
            "colorbar" => Dict("x" => 1.05),
        ),
    )

    tr = Dict(
        "type" => "heatmap",
        "colorscale" => NA_CA["Plotly"],
        "colorbar" => Dict("x" => 1.15, "dtick" => 1),
    )

    if !isempty(grr_)

        push!(
            data,
            OnePiece.Dict.merge(
                tr,
                Dict("xaxis" => "x2", "z" => [[gr] for gr in grr_][fl_], "hoverinfo" => "z+y"),
            ),
        )

    end

    if !isempty(grc_)

        push!(
            data,
            OnePiece.Dict.merge(tr, Dict("yaxis" => "y2", "z" => [grc_], "hoverinfo" => "z+x")),
        )

    end

    plot(data, layout, ht = ht)

end

function plot_heat_map(da::DataFrame; ke_ar...)

    nar, ro_, co_, ma = OnePiece.DataFrame.separate(da)

    plot_heat_map(ma, ro_, co_; nar = nar, ke_ar...)

end
