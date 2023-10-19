module Plot

using JSON: json

using ..BioLab

function plot(ht, data, layout = Dict{String, Any}(), config = Dict{String, Any}(); ke_ar...)

    id = "Plotly"

    BioLab.HTML.make(
        ht,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        id,
        "Plotly.newPlot(\"$id\", $(json(data)), $(json(layout)), $(json(merge!(Dict("displaylogo" => false), config))))";
        ke_ar...,
    )

end

function _x(an___)

    eachindex.(an___)

end

function _te(an___)

    [Vector{String}() for _ in an___]

end

function _na(an___)

    (id -> "Name $id").(eachindex(an___))

end

function _ma(an___)

    (he -> Dict("color" => he)).(BioLab.Color.color(eachindex(an___)))

end

const COLORBAR = Dict(
    "len" => 0.5,
    "thickness" => 16,
    "outlinecolor" => BioLab.Color.HEFA,
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

const _AX = Dict("showgrid" => false)

function plot_scatter(
    ht,
    y_,
    x_ = _x(y_);
    text_ = _te(y_),
    name_ = _na(y_),
    mode_ = (y -> ifelse(lastindex(y) < 1000, "markers+lines", "lines")).(y_),
    marker_ = _ma(y_),
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
        BioLab.Dict.merge(Dict("yaxis" => _AX, "xaxis" => _AX), layout);
        ke_ar...,
    )

end

function plot_bar(
    ht,
    y_,
    x_ = _x(y_);
    name_ = _na(y_),
    marker_ = _ma(y_),
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
        BioLab.Dict.merge(Dict("yaxis" => _AX, "xaxis" => _AX), layout);
        ke_ar...,
    )

end

# TODO: Fit and plot a line.
function plot_histogram(
    ht,
    x_,
    text_ = _te(x_);
    name_ = _na(x_),
    marker_ = _ma(x_),
    histnorm = "",
    xbins_size = 0,
    rug_marker_size = ifelse(all(x -> lastindex(x) < 100000, x_), 16, 0),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n = lastindex(x_)

    showlegend = 1 < n

    id_ = eachindex(x_)

    data = [
        Dict(
            "type" => "histogram",
            "legendgroup" => id,
            "name" => name_[id],
            "showlegend" => showlegend,
            "yaxis" => "y2",
            "x" => x_[id],
            "marker" => marker_[id],
            "histnorm" => histnorm,
            "xbins" => Dict("size" => xbins_size),
        ) for id in id_
    ]

    layout = BioLab.Dict.merge(
        Dict(
            "yaxis2" => Dict(
                "showgrid" => false,
                "title" => Dict("text" => ifelse(isempty(histnorm), "Count", titlecase(histnorm))),
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
                ) for id in id_
            ],
        )

        dm = min(0.04n, 0.5)

        layout["yaxis"] = Dict("domain" => (0, dm), "zeroline" => false, "tickvals" => ())

        layout["yaxis2"]["domain"] = (dm + 0.01, 1)

    end

    plot(ht, data, layout; ke_ar...)

end

function _it(it_)

    mi, ma = BioLab.Collection.get_minimum_maximum(it_)

    range(mi, ma)

end

function _it(fl_::AbstractArray{<:AbstractFloat})

    mi, ma = BioLab.Collection.get_minimum_maximum(fl_)

    range(mi, ma, 8)

end

function _gr(it_::AbstractVector{<:Integer}, an_, ma, ticktext = Vector{String}())

    id_ = BioLab.Clustering.order(it_, ma)

    it_[id_], an_[id_], ma[:, id_], ticktext

end

function _gr(st_, an_, ma)

    un_ = sort!(unique(st_))

    st_id = Dict(st => id for (id, st) in enumerate(un_))

    _gr([st_id[st] for st in st_], an_, ma, un_)

end

function _he!(ke_va, it_, colorbarx, ticktext)

    ke_va["type"] = "heatmap"

    ke_va["colorscale"] = BioLab.Color.fractionate(BioLab.Color.pick_color_scheme(it_))

    ke_va["colorbar"] = merge(
        COLORBAR,
        Dict("x" => colorbarx, "tickvals" => 1:maximum(it_), "ticktext" => ticktext),
    )

    ke_va

end

function plot_heat_map(
    ht,
    z;
    y = (id -> "$id ▶︎").(1:size(z, 1)),
    x = (id -> "▲ $id").(1:size(z, 2)),
    text = z,
    nar = "Row",
    nac = "Column",
    co = BioLab.Color.pick_color_scheme(z),
    grr_ = Vector{Int}(),
    grc_ = Vector{Int}(),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    if isempty(grr_)

        colorbarx = 0.97

    else

        colorbarx = 1.024

    end

    colorbarx1 = colorbarx

    data = Vector{Dict{String, Any}}()

    dx = 0.08

    if !isempty(grr_)

        gr_, y, z, ticktext = _gr(grr_, y, permutedims(z))

        z = permutedims(z)

        push!(
            data,
            _he!(
                Dict(
                    "name" => "$nar Group",
                    "xaxis" => "x2",
                    "y" => y,
                    "z" => [[gr] for gr in gr_],
                ),
                gr_,
                colorbarx += dx,
                ticktext,
            ),
        )

    end

    if !isempty(grc_)

        gr_, x, z, ticktext = _gr(grc_, x, z)

        push!(
            data,
            _he!(
                Dict("name" => "$nac Group", "yaxis" => "y2", "x" => x, "z" => [gr_]),
                gr_,
                colorbarx += dx,
                ticktext,
            ),
        )

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
            "colorscale" => BioLab.Color.fractionate(co),
            "colorbar" => merge(COLORBAR, Dict("x" => colorbarx1, "tickvals" => _it(z))),
        ),
    )

    ddy = 0.02

    ddx = 0.016

    ydomain = (0, 1 - 2ddy)

    xdomain = (0, 1 - 2ddx)

    plot(
        ht,
        data,
        BioLab.Dict.merge(
            Dict(
                "yaxis" => Dict(
                    "domain" => ydomain,
                    "autorange" => "reversed",
                    "title" => Dict("text" => "$nar ($(size(z, 1)))"),
                ),
                "xaxis" =>
                    Dict("domain" => xdomain, "title" => Dict("text" => "$nac ($(size(z, 2)))")),
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

function _ti(an_)

    vcat(an_, an_[1])

end

function plot_radar(
    ht,
    ra_,
    an_;
    name_ = _na(ra_),
    line_color_ = BioLab.Color.color(eachindex(ra_)),
    fillcolor_ = line_color_,
    radialaxis_range = (0, maximum(vcat(ra_...))),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    co = "#b83a4b"

    plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "name" => name_[id],
                "r" => _ti(ra_[id]),
                "theta" => _ti(an_[id]),
                "marker" => Dict("size" => 4.8, "color" => line_color_[id]),
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 1,
                    "color" => line_color_[id],
                ),
                "fill" => "toself",
                "fillcolor" => fillcolor_[id],
            ) for id in eachindex(ra_)
        ],
        BioLab.Dict.merge(
            Dict(
                "polar" => Dict(
                    "radialaxis" => Dict(
                        "range" => radialaxis_range,
                        "linewidth" => 2,
                        "linecolor" => co,
                        "ticklen" => 8,
                        "tickwidth" => 2,
                        "tickcolor" => co,
                        "tickfont" => Dict(
                            "family" => "Monospace",
                            "size" => 16,
                            "color" => "#1f4788",
                        ),
                        "gridwidth" => 2,
                        "gridcolor" => BioLab.Color.HEFA,
                    ),
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => 4,
                        "linecolor" => co,
                        "ticklen" => 16,
                        "tickwidth" => 2,
                        "tickcolor" => co,
                        "tickfont" =>
                            Dict("family" => "Optima", "size" => 32, "color" => "#23191e"),
                        "gridwidth" => 2,
                        "gridcolor" => BioLab.Color.HEFA,
                    ),
                ),
                "title" => Dict(
                    "x" => 0.02,
                    "font" => Dict(
                        "family" => "Times New Roman",
                        "size" => 48,
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

end

end
