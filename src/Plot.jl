module Plot

using Distances: CorrDist

using JSON: json

using ..Nucleus

function set_tickvals(nu_, ut = 10)

    mi, ma = Nucleus.Collection.get_minimum_maximum(nu_)

    if all(isinteger, nu_)

        collect(mi:1:ma)

    else

        va_ = collect(range(mi, ma, ut))

        for id in eachindex(va_)

            if 1 < id < lastindex(va_)

                va_[id] = round(va_[id])

            end

        end

        va_

    end

end

function plot(ht, data, layout = Dict{String, Any}(), config = Dict{String, Any}())

    layout = Nucleus.Dict.merge(
        Dict(
            "height" => 800,
            "width" => 1280,
            "hovermode" => "closest",
            "xaxis" => Dict("automargin" => true, "zeroline" => false, "showgrid" => false),
            "yaxis" => Dict("automargin" => true, "zeroline" => false, "showgrid" => false),
        ),
        layout,
    )

    config = merge(Dict("displaylogo" => false), config)

    Nucleus.HTML.make(
        ht,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        "Plotly20240506",
        "Plotly.newPlot(\"Plotly20240506\", $(json(data)), $(json(layout)), $(json(config)))";
    )

end

# TODO: Fit and plot a line.
function plot_histogram(
    ht,
    x_,
    text_ = (_ -> String[]).(eachindex(x_));
    name_ = eachindex.(x_),
    marker_ = (he -> Dict("color" => he)).(Nucleus.Color.color(eachindex(x_))),
    histnorm = "",
    xbins_size = 0,
    rug_marker_size = all(x -> lastindex(x) < 100000, x_) ? 16 : 0,
    layout = Dict{String, Any}(),
    ke_ar...,
)

    data = [
        Dict(
            "type" => "histogram",
            "legendgroup" => id,
            "name" => name_[id],
            "yaxis" => "y2",
            "x" => x_[id],
            "marker" => marker_[id],
            "histnorm" => histnorm,
            "xbins" => Dict("size" => xbins_size),
        ) for id in eachindex(x_)
    ]

    layout = Nucleus.Dict.merge(
        Dict(
            "showlegend" => 1 < lastindex(x_),
            "yaxis2" => Dict(
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
                    "legendgroup" => id,
                    "name" => name_[id],
                    "showlegend" => false,
                    "y" => fill(id, lastindex(x_[id])),
                    "x" => x_[id],
                    "text" => text_[id],
                    "mode" => "markers",
                    "marker" => merge(
                        marker_[id],
                        Dict("symbol" => "line-ns-open", "size" => rug_marker_size),
                    ),
                ) for id in eachindex(x_)
            ],
        )

        dm = min(0.04 * lastindex(x_), 0.5)

        layout = Nucleus.Dict.merge(
            layout,
            Dict(
                "yaxis" => Dict("domain" => (0, dm), "zeroline" => false, "tickvals" => ()),
                "yaxis2" =>
                    Dict("domain" => (dm + 0.01, 1), "zeroline" => false, "showgrid" => false),
            ),
        )

    end

    plot(ht, data, layout; ke_ar...)

end

function _label_row(nu)

    "$nu ●"

end

function _label_col(nu)

    "● $nu"

end

const COLORBAR = Dict(
    "len" => 0.5,
    "thickness" => 16,
    "outlinecolor" => Nucleus.Color.HEFA,
    "title" => Dict("font" => Dict("family" => "Droid Sans Mono", "size" => 13)),
    "tickfont" => Dict("family" => "Droid Sans Mono", "size" => 10),
)

function plot_heat_map(
    ht,
    z;
    y = _label_row.(1:size(z, 1)),
    x = _label_col.(1:size(z, 2)),
    text = z,
    co = Nucleus.Color.pick_color_scheme(z),
    gr_ = Int[],
    gc_ = Int[],
    fu = CorrDist(),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    colorbarx = isempty(gr_) ? 0.97 : 1.024

    colorbarx1 = colorbarx

    data = Dict{String, Any}[]

    dx = 0.08

    if !isempty(gr_)

        gi_ = eltype(gr_) <: Real ? gr_ : Nucleus.Number.integize(gr_)

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

        gi_ = eltype(gc_) <: Real ? gc_ : Nucleus.Number.integize(gc_)

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
                Dict("x" => colorbarx1, "tickvals" => set_titlevals(view(z, .!isnan.(z)))),
            ),
        ),
    )

    ddy = 0.02

    ddx = 0.016

    ydomain = 0, 1 - ddy * 2

    xdomain = 0, 1 - ddx * 2

    plot(
        ht,
        data,
        Nucleus.Dict.merge(
            Dict(
                "yaxis" => Dict("domain" => ydomain, "autorange" => "reversed"),
                "xaxis" => Dict("domain" => xdomain),
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

function plot_heat_map(
    pr,
    nr,
    ro_,
    nc,
    co_,
    nn,
    rc;
    ir_ = eachindex(ro_),
    ic_ = eachindex(co_),
    layout = Dict{String, Any}(),
)

    layout = Nucleus.Dict.merge(
        Dict(
            "title" => Dict("text" => nn),
            "yaxis" => Dict("title" => "$nr ($(lastindex(ro_)))"),
            "xaxis" => Dict("title" => "$nc ($(lastindex(co_)))"),
        ),
        layout,
    )

    plot_heat_map("$pr.html", rc; y = ro_, x = co_, layout)

    if ir_ != eachindex(ro_) || ic_ != eachindex(co_)

        layout["title"]["text"] *= " (ordered)"

        plot_heat_map(
            "$(pr).ordered.html",
            view(rc, ir_, ic_);
            y = view(ro_, ir_),
            x = view(co_, ic_),
            layout,
        )

    end

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
                "yaxis" => Dict("autorange" => "reversed", "dtick" => 1),
                "xaxis" => Dict("dtick" => 1, "tickangle" => 90),
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
