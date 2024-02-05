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

# TODO: Simplify initializations.

function _initialize_x(an___)

    eachindex.(an___)

end

function _initialize_text(an___)

    (_ -> String[]).(eachindex(an___))

end

function _initialize_name(an___)

    (i1 -> "Name $i1").(eachindex(an___))

end

function _initialize_marker(an___)

    (he -> Dict("color" => he)).(Nucleus.Color.color(eachindex(an___)))

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

function plot_scatter(
    ht,
    y_,
    x_ = _initialize_x(y_);
    text_ = _initialize_text(y_),
    name_ = _initialize_name(y_),
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
            ) for i1 in eachindex(y_)
        ],
        Nucleus.Dict.merge(Dict("yaxis" => _AX, "xaxis" => _AX), layout);
        ke_ar...,
    )

end

function plot_bar(
    ht,
    y_,
    x_ = _initialize_x(y_);
    name_ = _initialize_name(y_),
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
    text_ = _initialize_text(x_);
    name_ = _initialize_name(x_),
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

function _group(fu, it_::AbstractVector{<:Integer}, an_, ma, ticktext = String[])

    i1_ = Nucleus.Clustering.order(fu, it_, eachcol(ma))

    it_[i1_], an_[i1_], ma[:, i1_], ticktext

end

function _group(fu, st_, an_, ma)

    un_ = sort!(unique(st_))

    st_i1 = Dict(st => i1 for (i1, st) in enumerate(un_))

    _group(fu, [st_i1[st] for st in st_], an_, ma, un_)

end

function _make_group_heat_map!(ke_va, it_, colorbarx, ticktext)

    ke_va["type"] = "heatmap"

    ke_va["colorscale"] = Nucleus.Color.fractionate(Nucleus.Color.pick_color_scheme(it_))

    ke_va["colorbar"] = merge(
        COLORBAR,
        Dict("x" => colorbarx, "tickvals" => 1:maximum(it_), "ticktext" => ticktext),
    )

    ke_va

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
    nr = "Row",
    nc = "Column",
    co = Nucleus.Color.pick_color_scheme(z),
    gr_ = Int[],
    gc_ = Int[],
    fu = Nucleus.Distance.IN,
    layout = Dict{String, Any}(),
    ke_ar...,
)

    colorbarx = isempty(gr_) ? 0.97 : 1.024

    colorbarx1 = colorbarx

    data = Dict{String, Any}[]

    dx = 0.08

    if !isempty(gr_)

        go_, y, z, ticktext = _group(fu, gr_, y, permutedims(z))

        z = permutedims(z)

        push!(
            data,
            _make_group_heat_map!(
                Dict(
                    "name" => "$nr Group",
                    "xaxis" => "x2",
                    "y" => y,
                    "z" => [[gr] for gr in go_],
                    "hoverinfo" => "y+z",
                ),
                go_,
                colorbarx += dx,
                ticktext,
            ),
        )

    end

    if !isempty(gc_)

        go_, x, z, ticktext = _group(fu, gc_, x, z)

        push!(
            data,
            _make_group_heat_map!(
                Dict(
                    "name" => "$nc Group",
                    "yaxis" => "y2",
                    "x" => x,
                    "z" => [go_],
                    "hoverinfo" => "x+z",
                ),
                go_,
                colorbarx += dx,
                ticktext,
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
            "name" => "Data",
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
                "yaxis" => Dict(
                    "domain" => ydomain,
                    "autorange" => "reversed",
                    "automargin" => true,
                    "title" => Dict("text" => "$nr ($(size(z, 1)))"),
                ),
                "xaxis" => Dict(
                    "domain" => xdomain,
                    "automargin" => true,
                    "title" => Dict("text" => "$nc ($(size(z, 2)))"),
                ),
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
    bgcolor = nothing,
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
                "polar" => Dict(
                    "bgcolor" => bgcolor,
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
                            "size" => 32,
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
                    "x" => 0.02,
                    "font" => Dict(
                        "family" => "Times New Roman",
                        "size" => 32,
                        "color" => "#27221f",
                    ),
                ),
                "legend" => Dict(
                    "itemwidth" => 32,
                    "borderwidth" => linewidth,
                    "bordercolor" => bgcolor,
                    "bgcolor" => gridcolor,
                    "font" => Dict(
                        "family" => "Times New Roman",
                        "size" => 24,
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

    Nucleus.Path.open(gi)

end

end
