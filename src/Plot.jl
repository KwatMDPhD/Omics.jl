module Plot

using JSON: json

using ..BioLab

function plot(ht, data, layout = Dict{String, Any}(); config = Dict{String, Any}(), ke_ar...)

    id = "Plotly"

    daj = json(data)

    laj = json(layout)

    coj = json(BioLab.Dict.merge_recursively(Dict("displaylogo" => false), config))

    BioLab.HTML.make(
        ht,
        id,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        "Plotly.newPlot(\"$id\", $daj, $laj, $coj)";
        ke_ar...,
    )

end

function _set_x(y_)

    (y -> collect(eachindex(y))).(y_)

end

function _set_text(y_)

    [Vector{String}() for _ in eachindex(y_)]

end

function _set_name(y_)

    string.("Name ", eachindex(y_))

end

function _set_marker(y_)

    [Dict("color" => co) for co in color(collect(eachindex(y_)))]

end

const COLORBAR = Dict(
    "len" => 0.5,
    "thickness" => 16,
    "outlinecolor" => "#ebf6f7",
    "title" => Dict("font" => Dict("family" => "Droid Sans Mono", "size" => 12.8)),
    "tickfont" => Dict("family" => "Droid Sans Mono", "size" => 10),
)

const AXIS = Dict("automargin" => true, "showgrid" => false)

const SPIKE = Dict(
    "showspikes" => true,
    "spikesnap" => "cursor",
    "spikemode" => "across",
    "spikedash" => "solid",
    "spikethickness" => 1,
    "spikecolor" => "#561649",
)

function plot_scatter(
    ht,
    y_,
    x_ = _set_x(y_);
    text_ = _set_text(y_),
    name_ = _set_name(y_),
    mode_ = (y -> ifelse(length(y) < 10^3, "markers+lines", "lines")).(y_),
    marker_ = _set_marker(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        [
            Dict(
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "text" => text_[id],
                "mode" => mode_[id],
                "marker" => marker_[id],
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge_recursively(Dict("yaxis" => AXIS, "xaxis" => AXIS), layout);
        ke_ar...,
    )

end

function plot_bar(
    ht,
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_ = _set_marker(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        [
            Dict(
                "type" => "bar",
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "marker" => marker_[id],
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge_recursively(Dict("yaxis" => AXIS, "xaxis" => AXIS), layout);
        ke_ar...,
    )

end

# TODO: Plot fitted line.
function plot_histogram(
    ht,
    x_,
    text_ = _set_text(x_);
    rug_marker_size = ifelse(all(x -> length(x) < 100000, x_), 16, 0),
    name_ = _set_name(x_),
    marker_ = _set_marker(x_),
    histnorm = "",
    xbins_size = 0,
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n = length(x_)

    if 0 < rug_marker_size

        fr = min(n * 0.08, 0.5)

    else

        fr = 0

    end

    if isempty(histnorm)

        yaxis2_title_text = "Count"

    else

        yaxis2_title_text = titlecase(histnorm)

    end

    layout = BioLab.Dict.merge_recursively(
        Dict(
            "yaxis2" => BioLab.Dict.merge_recursively(
                AXIS,
                Dict("domain" => (fr, 1), "title" => Dict("text" => yaxis2_title_text)),
            ),
            "yaxis" => BioLab.Dict.merge_recursively(
                AXIS,
                Dict("domain" => (0, fr), "zeroline" => false, "tickvals" => ()),
            ),
            "xaxis" => AXIS,
        ),
        layout,
    )

    data = Vector{Dict{String, Any}}()

    showlegend = 1 < length(x_)

    for id in 1:n

        le = Dict(
            "showlegend" => showlegend,
            "legendgroup" => id,
            "name" => name_[id],
            "x" => x_[id],
            "marker" => marker_[id],
        )

        push!(
            data,
            BioLab.Dict.merge_recursively(
                le,
                Dict(
                    "yaxis" => "y2",
                    "type" => "histogram",
                    "histnorm" => histnorm,
                    "xbins" => Dict("size" => xbins_size),
                ),
            ),
        )

        if 0 < rug_marker_size

            push!(
                data,
                BioLab.Dict.merge_recursively(
                    le,
                    Dict(
                        "showlegend" => false,
                        "y" => fill(id, length(x_[id])),
                        "text" => text_[id],
                        "mode" => "markers",
                        "marker" => Dict("symbol" => "line-ns-open", "size" => rug_marker_size),
                        "hoverinfo" => "x+text+name",
                    ),
                ),
            )

        end

    end

    plot(ht, data, layout; ke_ar...)

end

function plot_heat_map(
    ht,
    z,
    y = string.(1:size(z, 1), " *"),
    x = string.("* ", 1:size(z, 2));
    text = z,
    nar = "Row",
    nac = "Column",
    colorscale = map_fraction_to_color(pick_color_scheme(z)),
    grr_ = Vector{Any}(),
    grc_ = Vector{Any}(),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n_ro, n_co = size(z)

    domain1 = (0, 0.95)

    axis2 = BioLab.Dict.merge_recursively(
        AXIS,
        Dict("domain" => (domain1[2] + 0.01, 1), "tickvals" => ()),
    )

    layout = BioLab.Dict.merge_recursively(
        Dict(
            "yaxis" => BioLab.Dict.merge_recursively(
                AXIS,
                Dict(
                    "domain" => domain1,
                    "autorange" => "reversed",
                    "title" => Dict("text" => "$nar (n=$n_ro)"),
                ),
            ),
            "xaxis" => BioLab.Dict.merge_recursively(
                AXIS,
                Dict("domain" => domain1, "title" => Dict("text" => "$nac (n=$n_co)")),
            ),
            "yaxis2" => BioLab.Dict.merge_recursively(axis2, Dict("autorange" => "reversed")),
            "xaxis2" => axis2,
        ),
        layout,
    )

    data = Vector{Dict{String, Any}}()

    colorbarx = 0.97

    dx = 0.064

    n_ti = 8

    # TODO: Cluster within a group.
    # TODO: Test String.
    # TODO: Label with String.

    if !isempty(grr_)

        if grr_ isa AbstractVector{<:AbstractString}

            gr_id = BioLab.Collection.map_index(BioLab.Collection.unique_sort(grr_))

            grr_ = [gr_id[gr] for gr in grr_]

        end

        colorbarx += 0.04

        so_ = sortperm(grr_)

        grr_ = view(grr_, so_)

        y = view(y, so_)

        z = view(z, so_, :)

    end

    if !isempty(grc_)

        if grc_ isa AbstractVector{<:AbstractString}

            gr_id = BioLab.Collection.map_index(BioLab.Collection.unique_sort(grc_))

            grc_ = [gr_id[gr] for gr in grc_]

        end

        so_ = sortperm(grc_)

        grc_ = view(grc_, so_)

        x = view(x, so_)

        z = view(z, :, so_)

    end

    push!(
        data,
        Dict(
            "type" => "heatmap",
            "name" => "Data",
            "z" => collect(eachrow(z)),
            "y" => y,
            "x" => x,
            "text" => collect(eachrow(text)),
            "colorscale" => colorscale,
            "colorbar" => BioLab.Dict.merge_recursively(
                COLORBAR,
                Dict("x" => colorbarx, "tickvals" => BioLab.Rank.range(z, n_ti)),
            ),
        ),
    )

    if !isempty(grr_)

        push!(
            data,
            Dict(
                "xaxis" => "x2",
                "type" => "heatmap",
                "name" => "Row Group",
                "z" => [[grr] for grr in grr_],
                "hoverinfo" => "y+z+name",
                "colorscale" => map_fraction_to_color(pick_color_scheme(grr_)),
                "colorbar" => BioLab.Dict.merge_recursively(
                    COLORBAR,
                    Dict("x" => (colorbarx += dx), "tickvals" => BioLab.Rank.range(grr_, n_ti)),
                ),
            ),
        )

    end

    if !isempty(grc_)

        push!(
            data,
            Dict(
                "yaxis" => "y2",
                "type" => "heatmap",
                "name" => "Column Group",
                "z" => [grc_],
                "hoverinfo" => "x+z+name",
                "colorscale" => map_fraction_to_color(pick_color_scheme(grc_)),
                "colorbar" => BioLab.Dict.merge_recursively(
                    COLORBAR,
                    Dict("x" => (colorbarx += dx), "tickvals" => BioLab.Rank.range(grc_, n_ti)),
                ),
            ),
        )

    end

    plot(ht, data, layout; ke_ar...)

end

function plot_radar(
    ht,
    theta_,
    r_;
    radialaxis_range = (0, maximum(vcat(r_...))),
    name_ = _set_name(theta_),
    line_color_ = color(collect(eachindex(theta_))),
    fillcolor_ = line_color_,
    layout = Dict{String, Any}(),
    ke_ar...,
)

    costa = "#b83a4b"

    cofai = "#ebf6f7"

    plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "name" => name_[id],
                "theta" => vcat(theta_[id], theta_[id][1]),
                "r" => vcat(r_[id], r_[id][1]),
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 1,
                    "color" => line_color_[id],
                ),
                "marker" => Dict("size" => 4, "color" => line_color_[id]),
                "fill" => "toself",
                "fillcolor" => fillcolor_[id],
            ) for id in eachindex(theta_)
        ],
        BioLab.Dict.merge_recursively(
            Dict(
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => 4,
                        "linecolor" => costa,
                        "ticklen" => 16,
                        "tickwidth" => 2,
                        "tickcolor" => costa,
                        "tickfont" =>
                            Dict("size" => 32, "family" => "Optima", "color" => "#23191e"),
                        "gridwidth" => 2,
                        "gridcolor" => cofai,
                    ),
                    "radialaxis" => Dict(
                        "range" => radialaxis_range,
                        "linewidth" => 2,
                        "linecolor" => costa,
                        "ticklen" => 8,
                        "tickwidth" => 2,
                        "tickcolor" => costa,
                        "tickfont" => Dict(
                            "size" => 16,
                            "family" => "Monospace",
                            "color" => "#1f4788",
                        ),
                        "gridwidth" => 1.6,
                        "gridcolor" => cofai,
                    ),
                ),
                "title" => Dict(
                    "x" => 0.02,
                    "font" => Dict(
                        "size" => 48,
                        "family" => "Times New Roman",
                        "color" => "#27221f",
                    ),
                ),
            ),
            layout,
        );
        ke_ar...,
    )

end

function animate(gi, pn_)

    run(`convert -delay 32 -loop 0 $pn_ $gi`)

    BioLab.Path.open(gi)

    gi

end

end
