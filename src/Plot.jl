module Plot

using JSON: json

using ..Nucleus

function plot(ht, data, layout = Dict{String, Any}(), config = Dict{String, Any}(); ke_ar...)

    id = "Plotly"

    layout = merge(Dict("hovermode" => "closest"), layout)

    config = merge(Dict("displaylogo" => false), config)

    Nucleus.HTML.make(
        ht,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        id,
        "Plotly.newPlot(\"$id\", $(json(data)), $(json(layout)), $(json(config)))";
        ke_ar...,
    )

end

const COLORBAR = Dict(
    "len" => 0.5,
    "thickness" => 16,
    "outlinecolor" => Nucleus.Color.HEFA,
    "title" => Dict("font" => Dict("family" => "Droid Sans Mono", "size" => 13)),
    "tickfont" => Dict("family" => "Droid Sans Mono", "size" => 10),
)

const SPIKE = Dict(
    "showspikes" => true,
    "spikesnap" => "cursor",
    "spikemode" => "across",
    "spikedash" => "solid",
    "spikethickness" => 1,
    "spikecolor" => "#561649",
)

const _AX = Dict("showgrid" => false, "automargin" => true)

function _initialize_marker(an___)

    (he -> Dict("color" => he)).(Nucleus.Color.color(eachindex(an___)))

end

function plot_scatter(
    ht,
    y_,
    x_ = eachindex.(y_);
    text_ = (_ -> String[]).(eachindex(y_)),
    name_ = eachindex.(y_),
    mode_ = (y -> lastindex(y) < 1000 ? "markers+lines" : "lines").(y_),
    marker_ = _initialize_marker(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        [
            Dict(
                "name" => name_[i1],
                "y" => y_[i1],
                "x" => x_[i1],
                "text" => text_[i1],
                "mode" => mode_[i1],
                "marker" => marker_[i1],
                "cliponaxis" => false,
            ) for i1 in eachindex(y_)
        ],
        Nucleus.Dict.merge(Dict("yaxis" => _AX, "xaxis" => _AX), layout);
        ke_ar...,
    )

end

function plot_bar(
    ht,
    y_,
    x_ = eachindex.(y_);
    text_ = (_ -> String[]).(eachindex(y_)),
    name_ = eachindex.(y_),
    marker_ = _initialize_marker(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        [
            Dict(
                "type" => "bar",
                "name" => name_[i1],
                "y" => y_[i1],
                "x" => x_[i1],
                "text" => text_[i1],
                "marker" => marker_[i1],
            ) for i1 in eachindex(y_)
        ],
        Nucleus.Dict.merge(Dict("yaxis" => _AX, "xaxis" => _AX), layout);
        ke_ar...,
    )

end

# TODO: Fit and plot a line.
function plot_histogram(
    ht,
    x_,
    text_ = (_ -> String[]).(eachindex(x_));
    name_ = eachindex.(x_),
    marker_ = _initialize_marker(x_),
    histnorm = "",
    xbins_size = 0,
    rug_marker_size = all(x -> lastindex(x) < 100000, x_) ? 16 : 0,
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n = lastindex(x_)

    i1_ = eachindex(x_)

    data = [
        Dict(
            "type" => "histogram",
            "legendgroup" => i1,
            "name" => name_[i1],
            "yaxis" => "y2",
            "x" => x_[i1],
            "marker" => marker_[i1],
            "histnorm" => histnorm,
            "xbins" => Dict("size" => xbins_size),
        ) for i1 in i1_
    ]

    layout = Nucleus.Dict.merge(
        Dict(
            "showlegend" => 1 < n,
            "yaxis2" => Dict(
                "showgrid" => false,
                "title" => Dict("text" => isempty(histnorm) ? "Count" : titlecase(histnorm)),
            ),
        ),
        layout,
    )

    if !iszero(rug_marker_size)

        # TODO: Show overlapping texts.

        append!(
            data,
            [
                Dict(
                    "legendgroup" => i1,
                    "name" => name_[i1],
                    "showlegend" => false,
                    "y" => fill(i1, lastindex(x_[i1])),
                    "x" => x_[i1],
                    "text" => text_[i1],
                    "mode" => "markers",
                    "marker" => merge(
                        marker_[i1],
                        Dict("symbol" => "line-ns-open", "size" => rug_marker_size),
                    ),
                ) for i1 in i1_
            ],
        )

        dm = min(0.04n, 0.5)

        layout["yaxis"] = Dict("domain" => (0, dm), "zeroline" => false, "tickvals" => ())

        layout["yaxis2"]["domain"] = (dm + 0.01, 1)

    end

    plot(ht, data, layout; ke_ar...)

end

function _label_row(nu)

    "$nu ●"

end

function _label_col(nu)

    "● $nu"

end

function plot_heat_map(
    ht,
    z;
    y = _label_row.(1:size(z, 1)),
    x = _label_col.(1:size(z, 2)),
    text = z,
    co = Nucleus.Color.pick_color_scheme(z),
    gr_ = Int[],
    gc_ = Int[],
    fu = Nucleus.Distance.CO,
    layout = Dict{String, Any}(),
    ke_ar...,
)

    colorbarx = isempty(gr_) ? 0.97 : 1.024

    colorbarx1 = colorbarx

    data = Dict{String, Any}[]

    dx = 0.08

    if !isempty(gr_)

        if eltype(gr_) <: Real

            gi_ = gr_

        else

            gi_ = Nucleus.Number.integize(gr_)

        end

        so_ = Nucleus.Clustering.order(fu, gi_, eachrow(z))

        gs_ = gr_[so_]

        push!(
            data,
            Dict(
                "type" => "heatmap",
                "xaxis" => "x2",
                "y" => y[so_],
                "z" => [[gi] for gi in gi_[so_]],
                "text" => [[gr] for gr in gs_],
                "colorscale" => Nucleus.Color.fractionate(Nucleus.Color.pick_color_scheme(gi_)),
                "colorbar" => merge(
                    COLORBAR,
                    Dict(
                        "x" => (colorbarx += dx),
                        "tickvals" => 1:maximum(gi_),
                        "ticktext" => unique(gs_),
                    ),
                ),
                "hoverinfo" => "y+z+text",
            ),
        )

    end

    if !isempty(gc_)

        if eltype(gc_) <: Real

            gi_ = gc_

        else

            gi_ = Nucleus.Number.integize(gc_)

        end

        so_ = Nucleus.Clustering.order(fu, gi_, eachcol(z))

        gs_ = gc_[so_]

        push!(
            data,
            Dict(
                "type" => "heatmap",
                "yaxis" => "y2",
                "x" => x[so_],
                "z" => [gi_[so_]],
                "text" => [gs_],
                "colorscale" => Nucleus.Color.fractionate(Nucleus.Color.pick_color_scheme(gi_)),
                "colorbar" => merge(
                    COLORBAR,
                    Dict(
                        "x" => (colorbarx += dx),
                        "tickvals" => 1:maximum(gi_),
                        "ticktext" => unique(gs_),
                    ),
                ),
                "hoverinfo" => "x+z+text",
            ),
        )

    end

    if eltype(z) <: AbstractFloat

        length = 8

        step = nothing

    else

        length = nothing

        step = 1

    end

    push!(
        data,
        Dict(
            "type" => "heatmap",
            "y" => y,
            "x" => x,
            "z" => collect(eachrow(z)),
            "text" => collect(eachrow(text)),
            "colorscale" => Nucleus.Color.fractionate(co),
            "colorbar" => merge(
                COLORBAR,
                Dict(
                    "x" => colorbarx1,
                    "tickvals" => range(
                        Nucleus.Collection.get_minimum_maximum(view(z, .!isnan.(z)))...;
                        length,
                        step,
                    ),
                ),
            ),
        ),
    )

    ddy = 0.02

    ddx = 0.016

    ydomain = (0, 1 - 2ddy)

    xdomain = (0, 1 - 2ddx)

    plot(
        ht,
        data,
        Nucleus.Dict.merge(
            Dict(
                "yaxis" =>
                    Dict("domain" => ydomain, "autorange" => "reversed", "automargin" => true),
                "xaxis" => Dict("domain" => xdomain, "automargin" => true),
                "yaxis2" => Dict(
                    "domain" => (ydomain[2] + ddy, 1),
                    "autorange" => "reversed",
                    "tickvals" => (),
                ),
                "xaxis2" => Dict("domain" => (xdomain[2] + ddx, 1), "tickvals" => ()),
            ),
            layout,
        );
        ke_ar...,
    )

end

function plot_bubble_map(
    ht,
    zs,
    zc = zs;
    si = 24,
    y = _label_row.(1:size(zs, 1)),
    x = _label_col.(1:size(zs, 2)),
    co = Nucleus.Color.pick_color_scheme(zc),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    nn = lastindex(zs)

    y2 = Vector{eltype(y)}(undef, nn)

    x2 = Vector{eltype(x)}(undef, nn)

    marker_size = Vector{eltype(zs)}(undef, nn)

    marker_color = Vector{eltype(zc)}(undef, nn)

    for (id, ca) in enumerate(CartesianIndices(zs))

        y2[id] = y[ca[1]]

        x2[id] = x[ca[2]]

        marker_size[id] = zs[ca]

        marker_color[id] = zc[ca]

    end

    plot(
        ht,
        [
            Dict(
                "y" => y2,
                "x" => x2,
                "mode" => "markers",
                "marker" => Dict(
                    "size" => marker_size * si,
                    "color" => marker_color,
                    "colorscale" => Nucleus.Color.fractionate(co),
                    "line" => Dict("color" => "#000000"),
                ),
            ),
        ],
        Nucleus.Dict.merge(
            Dict(
                "yaxis" => Dict(
                    "autorange" => "reversed",
                    "dtick" => 1,
                    "showgrid" => false,
                    "automargin" => true,
                ),
                "xaxis" => Dict("showgrid" => false, "automargin" => true, "dtick" => 1),
            ),
            layout,
        );
        ke_ar...,
    )

end

function _tie(an_)

    vcat(an_, an_[1])

end

function plot_radar(
    ht,
    an_,
    ra_;
    name_ = eachindex(an_),
    showlegend_ = fill(true, lastindex(an_)),
    line_color_ = Nucleus.Color.color(eachindex(an_)),
    fill_ = fill("toself", lastindex(an_)),
    fillcolor_ = line_color_,
    linewidth = 4.8,
    linecolor = "#351e1c",
    gridwidth = 1.6,
    gridcolor = Nucleus.Color.HEFA,
    ticklen = 24,
    angularaxis_tickfont_color = "#2e211b",
    radialaxis_range = (0, 1.1maximum(vcat(ra_...))),
    radialaxis_tickvals = nothing,
    radialaxis_tickfont_color = "#ffffff",
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "legendgroup" => name_[i1],
                "name" => name_[i1],
                "showlegend" => showlegend_[i1],
                "theta" => _tie(an_[i1]),
                "r" => _tie(ra_[i1]),
                "marker" => Dict("size" => linewidth, "color" => line_color_[i1]),
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 2.4,
                    "color" => line_color_[i1],
                ),
                "fill" => fill_[i1],
                "fillcolor" => fillcolor_[i1],
            ) for i1 in eachindex(ra_)
        ],
        Nucleus.Dict.merge(
            Dict(
                "margin" => Dict("t" => 160),
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => linewidth,
                        "linecolor" => linecolor,
                        "gridwidth" => gridwidth,
                        "gridcolor" => gridcolor,
                        "ticklen" => ticklen,
                        "tickwidth" => gridwidth,
                        "tickcolor" => linecolor,
                        "tickfont" => Dict(
                            "family" => "Optima",
                            "size" => 24,
                            "color" => angularaxis_tickfont_color,
                        ),
                    ),
                    "radialaxis" => Dict(
                        "range" => radialaxis_range,
                        "linewidth" => 0.32linewidth,
                        "linecolor" => linecolor,
                        "gridwidth" => gridwidth,
                        "gridcolor" => gridcolor,
                        "tickvals" => radialaxis_tickvals,
                        "ticklen" => 0.24ticklen,
                        "tickwidth" => gridwidth,
                        "tickcolor" => linecolor,
                        "tickfont" => Dict(
                            "family" => "Monospace",
                            "size" => 13,
                            "color" => radialaxis_tickfont_color,
                        ),
                        "tickangle" => 48,
                    ),
                ),
                "title" => Dict(
                    "x" => 0.008,
                    "font" => Dict(
                        "family" => "Times New Roman",
                        "size" => 32,
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

    gi = Nucleus.Path.clean(gi)

    run(`convert -delay 32 -loop 0 $pn_ $gi`)

    Nucleus.Path.open(gi)

end

end
