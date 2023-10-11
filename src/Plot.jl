module Plot

using JSON: json

using ..BioLab

function plot(ht, data, layout = Dict{String, Any}(), config = Dict{String, Any}(); ke_ar...)

    id = "Plotly"

    BioLab.HTML.make(
        ht,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        id,
        "Plotly.newPlot(\"$id\", $(json(data)), $(json(layout)), $(json(merge(Dict("displaylogo" => false), config))))";
        ke_ar...,
    )

end

function _set_x(an___)

    [eachindex(an_) for an_ in an___]

end

function _set_text(an___)

    [Vector{String}() for _ in an___]

end

function _set_name(an___)

    ["Name $id" for id in eachindex(an___)]

end

function _set_marker(an___)

    [Dict("color" => he) for he in BioLab.Color.color(eachindex(an___))]

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

function plot_scatter(
    ht,
    y_,
    x_ = _set_x(y_);
    text_ = _set_text(y_),
    name_ = _set_name(y_),
    mode_ = (y -> ifelse(length(y) < 1000, "markers+lines", "lines")).(y_),
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
        BioLab.Dict.merge(
            Dict("yaxis" => Dict("showgrid" => false), "xaxis" => Dict("showgrid" => false)),
            layout,
        );
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
        BioLab.Dict.merge(
            Dict("yaxis" => Dict("showgrid" => false), "xaxis" => Dict("showgrid" => false)),
            layout,
        );
        ke_ar...,
    )

end

# TODO: Fit and plot a line.
function plot_histogram(
    ht,
    x_,
    text_ = _set_text(x_);
    name_ = _set_name(x_),
    marker_ = _set_marker(x_),
    histnorm = "",
    xbins_size = 0,
    rug_marker_size = ifelse(all(x -> length(x) < 100000, x_), 16, 0),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n = length(x_)

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

    if isempty(histnorm)

        yaxis2_title_text = "Count"

    else

        yaxis2_title_text = titlecase(histnorm)

    end

    layout = BioLab.Dict.merge(
        Dict("yaxis2" =>
                Dict("showgrid" => false, "title" => Dict("text" => yaxis2_title_text))),
        layout,
    )

    if !iszero(rug_marker_size)

        append!(
            data,
            [
                Dict(
                    "legendgroup" => id,
                    "name" => name_[id],
                    "showlegend" => false,
                    "y" => fill(id, length(x_[id])),
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

        dm = min(n * 0.04, 0.5)

        layout["yaxis2"]["domain"] = (dm + 0.01, 1)

        layout["yaxis"] = Dict("domain" => (0, dm), "zeroline" => false, "tickvals" => ())

    end

    plot(ht, data, layout; ke_ar...)

end

function _range(fl_::AbstractArray{<:AbstractFloat}, n::Integer)

    mi, ma = BioLab.Collection.get_minimum_maximum(fl_)

    range(mi, ma, n)

end

function _range(it_, ::Integer)

    mi, ma = BioLab.Collection.get_minimum_maximum(it_)

    range(mi, ma)

end

function _group(gr_, an_, ma)

    if eltype(gr_) <: AbstractString

        gr_id = BioLab.Collection.map_index(BioLab.Collection.unique_sort(gr_))

        gr_ = [gr_id[gr] for gr in gr_]

        ticktext = string.(keys(gr_id))

    else

        ticktext = Vector{String}()

    end

    id_ = BioLab.Clustering.order(gr_, ma)

    gr_[id_], an_[id_], ma[:, id_], ticktext

end

function _make_group_trace!(ke_va, gr_, colorbarx, ticktext)

    ke_va["type"] = "heatmap"

    ke_va["colorscale"] = BioLab.Color.fractionate(BioLab.Color.pick_color_scheme(gr_))

    ke_va["colorbar"] = merge(
        COLORBAR,
        Dict("x" => colorbarx, "tickvals" => 1:maximum(gr_), "ticktext" => ticktext),
    )

    ke_va

end

function plot_heat_map(
    ht,
    z;
    y = ["$id *" for id in 1:size(z, 1)],
    x = ["* $id" for id in 1:size(z, 2)],
    text = z,
    nar = "Row",
    nac = "Column",
    co = BioLab.Color.pick_color_scheme(z),
    grr_ = (),
    grc_ = (),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    data = Vector{Dict{String, Any}}()

    if isempty(grr_)

        colorbarx = 0.97

    else

        colorbarx = 1.024

    end

    colorbar = merge(COLORBAR, Dict("x" => colorbarx, "tickvals" => _range(z, 8)))

    dx = 0.08

    if !isempty(grr_)

        gr_, y, z, ticktext = _group(grr_, y, permutedims(z))

        z = permutedims(z)

        push!(
            data,
            _make_group_trace!(
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

        gr_, x, z, ticktext = _group(grc_, x, z)

        push!(
            data,
            _make_group_trace!(
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
            "colorbar" => colorbar,
        ),
    )

    ydomain = (0, 0.939)

    xdomain = (0, 0.955)

    dd = 0.02

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
                    "domain" => (ydomain[2] + dd, 1),
                    "autorange" => "reversed",
                    "tickvals" => (),
                ),
                "xaxis2" => Dict("domain" => (xdomain[2] + dd, 1), "tickvals" => ()),
            ),
            layout,
        );
        ke_ar...,
    )

end

function plot_radar(
    ht,
    ra_,
    an_;
    name_ = _set_name(ra_),
    line_color_ = BioLab.Color.color(eachindex(ra_)),
    fillcolor_ = line_color_,
    radialaxis_range = (0, maximum(vcat(ra_...))),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    cos = "#b83a4b"

    plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "name" => name_[id],
                "r" => vcat(ra_[id], ra_[id][1]),
                "theta" => vcat(an_[id], an_[id][1]),
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
                        "linecolor" => cos,
                        "ticklen" => 8,
                        "tickwidth" => 2,
                        "tickcolor" => cos,
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
                        "linecolor" => cos,
                        "ticklen" => 16,
                        "tickwidth" => 2,
                        "tickcolor" => cos,
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
