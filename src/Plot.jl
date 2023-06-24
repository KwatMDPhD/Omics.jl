module Plot

using ColorSchemes: ColorScheme, bwr, plasma

using Colors: Colorant, hex

using DataFrames: DataFrame

using JSON3: write

using Printf: @sprintf

using ..BioLab

function make_color_scheme(he_, ca, no)

    BioLab.Collection.error_no_change(he_)

    # TODO: Benchmark against map.
    ColorScheme([parse(Colorant{Float64}, he) for he in he_], ca, no)

end

const _CO = "continuous"

const _CA = "categorical"

const _BI = "binary"

const COBWR = ColorScheme(bwr.colors, _CO, "Blue White Red")

const COPLA = ColorScheme(plasma.colors, _CO, "PLAsma")

const COPL3 = make_color_scheme(
    (
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
    ),
    _CO,
    "PLotly3",
)

const COASP = make_color_scheme(
    ("#00936e", "#a4e2b4", "#e0f5e5", "#ffffff", "#fff8d1", "#ffec9f", "#ffd96a"),
    _CO,
    "ASPen",
)

const COPLO = make_color_scheme(
    (
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
    ),
    _CA,
    "PLOtly",
)

const COGUA = make_color_scheme(("#20d9ba", "#9017e6", "#4e40d8", "#ff1968"), _CA, "GUArdiome")

const COBIN = make_color_scheme(("#006442", "#ffb61e"), _BI, "BINary")

const COHUM = make_color_scheme(("#4b3c39", "#ffddca"), _BI, "HUMan")

const COSTA = make_color_scheme(("#8c1515", "#175e54"), _BI, "STAnford")

function _make_hex(rg)

    he = lowercase(hex(rg))

    "#$he"

end

function color(co, nu)

    _make_hex(co[nu])

end

function fractionate(co)

    collect(zip(0:(1 / (length(co) - 1)):1, _make_hex(rg) for rg in co))

end

function plot(ht, data, layout = Dict{String, Any}(); config = Dict{String, Any}(), ke_ar...)

    id = "Plotly"

    daj = write(data)

    axis = Dict("automargin" => true)

    laj = write(
        BioLab.Dict.merge(
            Dict("hovermode" => "closest", "yaxis" => axis, "xaxis" => axis),
            layout,
        ),
    )

    coj = write(merge!(Dict("displaylogo" => false), config))

    BioLab.HTML.write(
        ht,
        id,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        """Plotly.newPlot("$id", $daj, $laj, $coj)""";
        ke_ar...,
    )

end

function _set_x(y_)

    [collect(eachindex(y)) for y in y_]

end

function _set_text(y_)

    fill(Vector{String}(), length(y_))

end

function _set_name(y_)

    ["Name $id" for id in eachindex(y_)]

end

function _set_color(y_, co = COPLO)

    n = length(y_) - 1

    if iszero(n)

        nu_ = 1:1

    else

        nu_ = 0:(1 / n):1

    end

    [color(co, nu) for nu in nu_]

end

function _set_opacity(y_)

    fill(0.8, length(y_))

end

function plot_scatter(
    ht,
    y_,
    x_ = _set_x(y_),
    text_ = _set_text(y_);
    name_ = _set_name(y_),
    mode_ = [ifelse(length(y) < 10^3, "markers+lines", "lines") for y in y_],
    marker_color_ = _set_color(y_),
    opacity_ = _set_opacity(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    plot(
        ht,
        # TODO: Check if mapping using a variable of the parent scope slows the performance.
        [
            Dict(
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "text" => text_[id],
                "mode" => mode_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => opacity_[id]),
            ) for id in eachindex(y_)
        ],
        layout;
        ke_ar...,
    )

end

function plot_bar(
    ht,
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_color_ = _set_color(y_),
    opacity_ = _set_opacity(y_),
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
                "marker" => Dict("color" => marker_color_[id], "opacity" => opacity_[id]),
            ) for id in eachindex(y_)
        ],
        merge!(Dict("barmode" => "stack"), layout);
        ke_ar...,
    )

end

function plot_histogram(
    ht,
    x_,
    text_ = _set_text(x_);
    rug_marker_size = ifelse(all(length(x) < 100000 for x in x_), 16, 0),
    name_ = _set_name(x_),
    marker_color_ = _set_color(x_),
    opacity_ = _set_opacity(x_),
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
            "yaxis" => Dict(
                "domain" => (0, fr),
                "zeroline" => false,
                "dtick" => 1,
                "showticklabels" => false,
            ),
            "yaxis2" =>
                Dict("domain" => (fr, 1), "title" => Dict("text" => yaxis2_title_text)),
            "xaxis" => Dict("anchor" => "y"),
        ),
        layout,
    )

    data = Vector{Dict{String, Any}}()

    showlegend = 1 < length(x_)

    for id in 1:n

        marker = Dict("color" => marker_color_[id], "opacity" => opacity_[id])

        le = Dict(
            "showlegend" => showlegend,
            "legendgroup" => id,
            "name" => name_[id],
            "x" => x_[id],
            "marker" => marker,
        )

        push!(
            data,
            merge(
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
                merge(
                    le,
                    Dict(
                        "showlegend" => false,
                        "y" => fill(id, length(x_[id])),
                        "text" => text_[id],
                        "mode" => "markers",
                        "marker" => merge(
                            marker,
                            Dict("symbol" => "line-ns-open", "size" => rug_marker_size),
                        ),
                        "hoverinfo" => "x+text",
                    ),
                ),
            )

        end

    end

    plot(ht, data, layout; ke_ar...)

end

function _make_colorbar(z)

    tickvals = BioLab.NumberArray.range(z, 10)

    Dict(
        "thicknessmode" => "fraction",
        "thickness" => 0.024,
        "len" => 0.5,
        "tickvmode" => "array",
        "tickvals" => tickvals,
        "ticktext" => [@sprintf("%.3g", ti) for ti in tickvals],
        "ticks" => "outside",
        "tickfont" => Dict("size" => 10),
    )

end

function plot_heat_map(
    ht,
    z::AbstractMatrix,
    y = ["$id *" for id in 1:size(z, 1)],
    x = ["* $id" for id in 1:size(z, 2)];
    text = z,
    nar = "Row",
    nac = "Column",
    colorscale = fractionate(COBWR),
    grr_ = Vector{Int}(),
    grc_ = Vector{Int}(),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n_ro, n_co = size(z)

    domain1 = (0, 0.95)

    axis2 = Dict("domain" => (0.96, 1), "tickvals" => ())

    layout = BioLab.Dict.merge(
        Dict(
            "yaxis" => Dict(
                "domain" => domain1,
                "autorange" => "reversed",
                "title" => Dict("text" => "$nar (n=$n_ro)"),
            ),
            "yaxis2" => merge(axis2, Dict("autorange" => "reversed")),
            "xaxis" => Dict("domain" => domain1, "title" => Dict("text" => "$nac (n=$n_co)")),
            "xaxis2" => axis2,
        ),
        layout,
    )

    data = Vector{Dict{String, Any}}()

    # TODO: Cluster within a group.

    colorbarx = 1

    if !isempty(grr_)

        colorbarx += 0.04

        if eltype(grr_) <: AbstractString

            gr_id = BioLab.Collection.index(unique(grr_))[1]

            grr_ = [gr_id[gr] for gr in grr_]

        end

        so_ = sortperm(grr_)

        grr_ = grr_[so_]

        y = y[so_]

        z = z[so_, :]

    end

    if !isempty(grc_)

        # TODO: Test.
        if eltype(grc_) <: AbstractString

            gr_id = BioLab.Collection.index(unique(grc_))[1]

            grc_ = [gr_id[gr] for gr in grc_]

        end

        so_ = sortperm(grc_)

        grc_ = grc_[so_]

        x = x[so_]

        z = z[:, so_]

    end

    heatmap = Dict("type" => "heatmap")

    push!(
        data,
        merge(
            heatmap,
            Dict(
                "z" => collect(eachrow(z)),
                "y" => y,
                "x" => x,
                "text" => collect(eachrow(text)),
                "hoverinfo" => "y+x+z+text",
                "colorscale" => colorscale,
                "colorbar" => merge(_make_colorbar(z), Dict("x" => colorbarx)),
            ),
        ),
    )

    heatmapg = merge(heatmap, Dict("colorscale" => fractionate(COPLO)))

    if !isempty(grr_)

        colorbarx += 0.06

        push!(
            data,
            merge(
                heatmapg,
                Dict(
                    "xaxis" => "x2",
                    "z" => [[grr] for grr in grr_],
                    "hoverinfo" => "y+z",
                    "colorbar" => merge(_make_colorbar(grr_), Dict("x" => colorbarx)),
                ),
            ),
        )

    end


    if !isempty(grc_)

        colorbarx += 0.06

        push!(
            data,
            merge(
                heatmapg,
                Dict(
                    "yaxis" => "y2",
                    "z" => [grc_],
                    "hoverinfo" => "x+z",
                    "colorbar" => merge(_make_colorbar(grc_), Dict("x" => colorbarx)),
                ),
            ),
        )

    end

    plot(ht, data, layout; ke_ar...)

end

function plot_heat_map(ht, da; ke_ar...)

    nar, ro_, co_, ro_x_co_x_nu = BioLab.DataFrame.separate(da)

    plot_heat_map(ht, ro_x_co_x_nu, ro_, co_; nar, ke_ar...)

end

function plot_radar(
    ht,
    theta_,
    r_;
    radialaxis_range = (0, maximum(vcat(r_...))),
    name_ = _set_name(theta_),
    line_color_ = _set_color(theta_),
    fillcolor_ = line_color_,
    opacity_ = _set_opacity(theta_),
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
                "opacity" => opacity_[id],
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
                        "ticks" => "",
                        "tickfont" =>
                            Dict("size" => 32, "family" => "Optima", "color" => "#23191e"),
                        "linewidth" => 4,
                        "linecolor" => costa,
                        "gridwidth" => 2,
                        "gridcolor" => cofai,
                    ),
                    "radialaxis" => Dict(
                        "range" => radialaxis_range,
                        "nticks" => 10,
                        "tickcolor" => costa,
                        "tickangle" => 90,
                        "tickfont" => Dict(
                            "size" => 12,
                            "family" => "Monospace",
                            "color" => "#1f4788",
                        ),
                        "linewidth" => 0.8,
                        "linecolor" => costa,
                        "gridwidth" => 1.2,
                        "gridcolor" => cofai,
                    ),
                ),
                "title" => Dict(
                    "x" => 0.01,
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

    BioLab.Path.warn_overwrite(gi)

    BioLab.Path.error_extension_difference(gi, "gif")

    run(`convert -delay 32 -loop 0 $pn_ $gi`)

    BioLab.Path.open(gi)

end

end
