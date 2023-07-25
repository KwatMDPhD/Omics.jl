module Plot

using ColorSchemes: ColorScheme, bwr, plasma

using Colors: Colorant, hex

using JSON: json

using BioLab

function make_color_scheme(he_)

    ColorScheme([parse(Colorant{Float64}, he) for he in he_])

end

const COBWR = bwr

const COPLA = plasma

const COPL3 = make_color_scheme((
    "#0508b8",
    "#1910d8",
    "#3c19f0",
    "#6b1cfb",
    "#981cfd",
    "#bf1cfd",
    "#dd2bfd",
    "#f246fe",
    "#fc67fd",
    "#fe88fc",
    "#fea5fd",
    "#febefe",
    "#fec3fe",
))

const COASP = make_color_scheme((
    "#00936e",
    "#a4e2b4",
    "#e0f5e5",
    "#ffffff",
    "#fff8d1",
    "#ffec9f",
    "#ffd96a",
))

const COPLO = make_color_scheme((
    "#636efa",
    "#ef553b",
    "#00cc96",
    "#ab63fa",
    "#ffa15a",
    "#19d3f3",
    "#ff6692",
    "#b6e880",
    "#ff97ff",
    "#fecb52",
))

const COGUA = make_color_scheme(("#20d9ba", "#9017e6", "#4e40d8", "#ff1968"))

const COBIN = make_color_scheme(("#006442", "#ffb61e"))

const COHUM = make_color_scheme(("#4b3c39", "#ffddca"))

const COSTA = make_color_scheme(("#8c1515", "#175e54"))

const COMON = make_color_scheme(("#fbb92d",))

function _make_hex(rg)

    he = lowercase(hex(rg))

    "#$he"

end

function map_fraction_to_color(co)

    collect(zip(0:(1 / (length(co) - 1)):1, _make_hex(rg) for rg in co))

end

function pick_color_scheme(::AbstractArray{Float64})

    COBWR

end

function pick_color_scheme(it_)

    n = length(unique(it_))

    if n <= 1

        COMON

    elseif n <= 2

        COBIN

    else

        COPLO

    end

end

function color(nu::Real, co)

    _make_hex(co[nu])

end

function color(nu_, co = pick_color_scheme(nu_))

    fl_ = Vector{Float64}(undef, length(nu_))

    copy!(fl_, nu_)

    BioLab.Number.normalize_with_01!(fl_)

    (nu -> color(nu, co)).(fl_)

end

function plot(ht, data, layout = Dict{String, Any}(); config = Dict{String, Any}(), ke_ar...)

    id = "Plotly"

    daj = json(data)

    laj = json(layout)

    coj = json(BioLab.Dict.merge(Dict("displaylogo" => false), config))

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

function _set_color(y_)

    color(eachindex(y_))

end

const AXIS = Dict("automargin" => true, "showgrid" => false)

#const SPIKE = Dict(
#    "showspikes" => true,
#    "spikesnap" => "cursor",
#    "spikemode" => "across",
#    "spikedash" => "solid",
#    "spikethickness" => 1,
#    "spikecolor" => "#561649",
#)
#
function plot_scatter(
    ht,
    y_,
    x_ = _set_x(y_);
    text_ = _set_text(y_),
    name_ = _set_name(y_),
    mode_ = (y -> ifelse(length(y) < 10^3, "markers+lines", "lines")).(y_),
    marker_color_ = _set_color(y_),
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
                "marker" => Dict("color" => marker_color_[id]),
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge(Dict("yaxis" => AXIS, "xaxis" => AXIS), layout);
        ke_ar...,
    )

end

function plot_bar(
    ht,
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_color_ = _set_color(y_),
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
                "marker" => Dict("color" => marker_color_[id]),
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge(Dict("yaxis" => AXIS, "xaxis" => AXIS), layout);
        ke_ar...,
    )

end

function plot_histogram(
    ht,
    x_,
    text_ = _set_text(x_);
    rug_marker_size = ifelse(all(x -> length(x) < 100000, x_), 16, 0),
    name_ = _set_name(x_),
    marker_color_ = _set_color(x_),
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

    layout = BioLab.Dict.merge(
        Dict(
            "yaxis" => BioLab.Dict.merge(
                AXIS,
                Dict("domain" => (0, fr), "zeroline" => false, "tickvals" => ()),
            ),
            "yaxis2" => BioLab.Dict.merge(
                AXIS,
                Dict("domain" => (fr, 1), "title" => Dict("text" => yaxis2_title_text)),
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
            "marker" => Dict("color" => marker_color_[id]),
        )

        push!(
            data,
            BioLab.Dict.merge(
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
                BioLab.Dict.merge(
                    le,
                    Dict(
                        "showlegend" => false,
                        "y" => fill(id, length(x_[id])),
                        "text" => text_[id],
                        "mode" => "markers",
                        "marker" => Dict("symbol" => "line-ns-open", "size" => rug_marker_size),
                        "hoverinfo" => "x+text",
                    ),
                ),
            )

        end

    end

    plot(ht, data, layout; ke_ar...)

end

function _make_colorbar(x, z)

    tickvals = BioLab.Vector.range(z, 10)

    Dict(
        "x" => x,
        "thicknessmode" => "fraction",
        "thickness" => 0.02,
        "len" => 0.5,
        "tickvals" => tickvals,
    )

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
    grr_ = Vector{Union{Int, AbstractString}}(),
    grc_ = Vector{Union{Int, AbstractString}}(),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n_ro, n_co = size(z)

    domain1 = (0, 0.95)

    axis2 = BioLab.Dict.merge(AXIS, Dict("domain" => (domain1[2] + 0.01, 1), "tickvals" => ()))

    layout = BioLab.Dict.merge(
        Dict(
            "yaxis" => BioLab.Dict.merge(
                AXIS,
                Dict(
                    "domain" => domain1,
                    "autorange" => "reversed",
                    "title" => Dict("text" => "$nar (n=$n_ro)"),
                ),
            ),
            "xaxis" => BioLab.Dict.merge(
                AXIS,
                Dict("domain" => domain1, "title" => Dict("text" => "$nac (n=$n_co)")),
            ),
            "yaxis2" => BioLab.Dict.merge(axis2, Dict("autorange" => "reversed")),
            "xaxis2" => axis2,
        ),
        layout,
    )

    data = Vector{Dict{String, Any}}()

    colorbarx = 1

    # TODO: Cluster within a group.

    if !isempty(grr_)

        colorbarx += 0.04

        so_ = sortperm(grr_)

        grr_ = view(grr_, so_)

        y = view(y, so_)

        z = view(z, so_, :)

    end

    if !isempty(grc_)

        so_ = sortperm(grc_)

        grc_ = view(grc_, so_)

        x = view(x, so_)

        z = view(z, :, so_)

    end

    push!(
        data,
        Dict(
            "type" => "heatmap",
            "z" => collect(eachrow(z)),
            "y" => y,
            "x" => x,
            "text" => collect(eachrow(text)),
            "hoverinfo" => "y+x+z+text",
            "colorscale" => colorscale,
            "colorbar" => _make_colorbar(colorbarx, z),
        ),
    )

    if !isempty(grr_)

        push!(
            data,
            Dict(
                "type" => "heatmap",
                "xaxis" => "x2",
                "z" => [[grr] for grr in grr_],
                "hoverinfo" => "y+z",
                "colorscale" => map_fraction_to_color(pick_color_scheme(grr_)),
                "colorbar" => _make_colorbar(colorbarx += 0.06, grr_),
            ),
        )

    end

    if !isempty(grc_)

        push!(
            data,
            Dict(
                "type" => "heatmap",
                "yaxis" => "y2",
                "z" => [grc_],
                "hoverinfo" => "x+z",
                "colorscale" => map_fraction_to_color(pick_color_scheme(grc_)),
                "colorbar" => _make_colorbar(colorbarx += 0.06, grc_),
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
    line_color_ = _set_color(theta_),
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
        BioLab.Dict.merge(
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

end

end
