module Plot

using ColorSchemes: ColorScheme, plasma

using Colors: Colorant, hex

using DataFrames: DataFrame

using JSON3: write

using ..BioLab

function _make_color_scheme(he_)

    return ColorScheme([parse(Colorant, he) for he in he_])

end

const COPLA = plasma

const COPL3 = _make_color_scheme((
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

const COPLO = _make_color_scheme((
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

const COBIN = _make_color_scheme(("#006442", "#ffffff", "#ffb61e"))

const COASP = _make_color_scheme((
    "#00936e",
    "#a4e2b4",
    "#e0f5e5",
    "#ffffff",
    "#fff8d1",
    "#ffec9f",
    "#ffd96a",
))

const COHUM = _make_color_scheme(("#4b3c39", "#ffffff", "#ffddca"))

const COSTA = _make_color_scheme(("#ffffff", "#8c1515"))

function color(co, nu)

    return "#$(hex(co[nu]))"

end

function fractionate(co)

    return collect(zip(0:(1 / (length(co) - 1)):1, "#$(hex(rg))" for rg in co))

end

function plot(data, layout = Dict{String, Any}(); config = Dict{String, Any}(), ke_ar...)

    axis = Dict("automargin" => true)

    di = "BioLab.Plot.plot.$(BioLab.Time.stamp())"

    return BioLab.HTML.write(
        di,
        ("https://cdn.plot.ly/plotly-latest.min.js",),
        """
        Plotly.newPlot(
            "$di",
            $(write(data)),
            $(write(BioLab.Dict.merge(
                Dict("hovermode" => "closest", "yaxis" => axis, "xaxis" => axis),
                layout,
                BioLab.Dict.set_with_last!,
            ))),
            $(write(BioLab.Dict.merge(
                Dict(
                    "displaylogo" => false,
                ),
                config,
                BioLab.Dict.set_with_last!,
            ))),
        )
        """;
        ke_ar...,
    )

end

function _set_x(y_)

    return [collect(eachindex(y)) for y in y_]

end

function _set_text(y_)

    return fill(Vector{String}(), length(y_))

end

function _set_name(y_)

    return ["Name $id" for id in eachindex(y_)]

end

function _set_color(y_)

    n = length(y_) - 1

    if n == 0

        nu_ = 1:1

    else

        nu_ = 0:(1 / n):1

    end

    return [color(COPLO, nu) for nu in nu_]

end

function _set_mode(y_)

    return [ifelse(length(y) < 10^3, "markers+lines", "lines") for y in y_]

end

function plot_scatter(
    y_,
    x_ = _set_x(y_),
    text_ = _set_text(y_);
    name_ = _set_name(y_),
    mode_ = _set_mode(y_),
    marker_color_ = _set_color(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    return plot(
        [
            Dict(
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "text" => text_[id],
                "mode" => mode_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
            ) for id in eachindex(y_)
        ],
        layout;
        ke_ar...,
    )

end

function plot_bar(
    y_,
    x_ = _set_x(y_);
    name_ = _set_name(y_),
    marker_color_ = _set_color(y_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    return plot(
        [
            Dict(
                "type" => "bar",
                "name" => name_[id],
                "y" => y_[id],
                "x" => x_[id],
                "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
            ) for id in eachindex(y_)
        ],
        BioLab.Dict.merge(Dict("barmode" => "stack"), layout, BioLab.Dict.set_with_last!);
        ke_ar...,
    )

end

function plot_histogram(
    x_,
    text_ = _set_text(x_);
    name_ = _set_name(x_),
    histnorm = "",
    xbins_size = 0.0,
    marker_color_ = _set_color(x_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    ru = all(length(x) < 10^5 for x in x_)

    n = length(x_)

    if ru

        fr = min(n * 0.08, 0.5)

    else

        fr = 0.0

    end

    if isempty(histnorm)

        yaxis2_title = "N"

    else

        yaxis2_title = titlecase(histnorm)

    end

    layout = BioLab.Dict.merge(
        Dict(
            "yaxis" => Dict(
                "domain" => (0.0, fr),
                "zeroline" => false,
                "dtick" => 1,
                "showticklabels" => false,
            ),
            "yaxis2" => Dict("domain" => (fr, 1.0), "title" => Dict("text" => yaxis2_title)),
            "xaxis" => Dict("anchor" => "y"),
        ),
        layout,
        BioLab.Dict.set_with_last!,
    )

    data = Vector{Dict{String, Any}}()

    for id in 1:n

        le = Dict(
            "legendgroup" => id,
            "name" => name_[id],
            "x" => x_[id],
            "marker" => Dict("color" => marker_color_[id], "opacity" => 0.8),
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
                BioLab.Dict.set_with_last!,
            ),
        )

        if ru

            push!(
                data,
                BioLab.Dict.merge(
                    le,
                    Dict(
                        "showlegend" => false,
                        "y" => fill(id, length(x_[id])),
                        "text" => text_[id],
                        "mode" => "markers",
                        "marker" => Dict("symbol" => "line-ns-open", "size" => 16),
                        "hoverinfo" => "x+text",
                    ),
                    BioLab.Dict.set_with_last!,
                ),
            )

        end

    end

    return plot(data, layout; ke_ar...)

end

function plot_heat_map(
    z::AbstractMatrix,
    y = ["$id *" for id in 1:size(z, 1)],
    x = ["* $id" for id in 1:size(z, 2)];
    nar = "Row",
    nac = "Column",
    colorscale = fractionate(COPLA),
    grr_ = [],
    grc_ = [],
    layout = Dict{String, Any}(),
    ke_ar...,
)

    n_ro, n_co = size(z)

    axis = Dict("domain" => (0.0, 0.95))

    axis2 = Dict("domain" => (0.96, 1.0), "tickvals" => ())

    layout = BioLab.Dict.merge(
        Dict(
            "title" => Dict("text" => "Heat Map"),
            "yaxis" => merge(axis, Dict("title" => Dict("text" => "$nar (n=$n_ro)"))),
            "xaxis" => merge(axis, Dict("title" => Dict("text" => "$nac (n=$n_co)"))),
            "yaxis2" => axis2,
            "xaxis2" => axis2,
        ),
        layout,
        BioLab.Dict.set_with_last!,
    )

    data = Vector{Dict{String, Any}}()

    # TODO: Cluster within a group.

    if !isempty(grr_)

        if eltype(grr_) <: AbstractString

            gr_id = BioLab.Collection.pair_index(unique(grr_))[1]

            grr_ = [gr_id[gr] for gr in grr_]

        end

        so_ = sortperm(grr_)

        grr_ = grr_[so_]

        y = y[so_]

        z = z[so_, :]

    end

    if !isempty(grc_)

        if eltype(grc_) <: AbstractString

            gr_id = BioLab.Collection.pair_index(unique(grc_))[1]

            grc_ = [gr_id[gr] for gr in grc_]

        end

        so_ = sortperm(grc_)

        grc_ = grc_[so_]

        x = x[so_]

        z = z[:, so_]

    end

    # TODO: Check if Plotly has an option for flipping y.
    fl_ = n_ro:-1:1

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

    trace = Dict(
        "type" => "heatmap",
        "colorscale" => fractionate(COPLO),
        "colorbar" => Dict("x" => 1.15, "dtick" => 1),
    )

    if !isempty(grr_)

        push!(
            data,
            BioLab.Dict.merge(
                trace,
                Dict("xaxis" => "x2", "z" => [[grr] for grr in grr_][fl_], "hoverinfo" => "z+y"),
                BioLab.Dict.set_with_last!,
            ),
        )

    end

    if !isempty(grc_)

        push!(
            data,
            BioLab.Dict.merge(
                trace,
                Dict("yaxis" => "y2", "z" => [grc_], "hoverinfo" => "z+x"),
                BioLab.Dict.set_with_last!,
            ),
        )

    end

    return plot(data, layout; ke_ar...)

end

function plot_heat_map(ro_x_co_x_nu; ke_ar...)

    ro, ro_, co_, ro_x_co_x_nu = BioLab.DataFrame.separate(ro_x_co_x_nu)

    return plot_heat_map(ro_x_co_x_nu, ro_, co_; nar = ro, ke_ar...)

end

function plot_radar(
    theta_,
    r__;
    name_ = _set_name(theta_),
    marker_color_ = _set_color(theta_),
    layout = Dict{String, Any}(),
    ke_ar...,
)

    axis = Dict(
        "linewidth" => 1.6,
        "linecolor" => "#48929b",
        "gridwidth" => 1.2,
        "gridcolor" => "#ebf6f7",
        "tickfont" => Dict("color" => "#1f4788"),
    )

    return plot(
        [
            Dict(
                "type" => "scatterpolar",
                "name" => name,
                "theta" => theta,
                "r" => r_,
                "opacity" => 0.64,
                "marker" => Dict("symbol" => "diamond", "size" => 2, "color" => marker_color),
                "line" => Dict("width" => 0),
                "fill" => "toself",
                "fillcolor" => marker_color,
            ) for (theta, r_, name, marker_color) in zip(theta_, r__, name_, marker_color_)
        ],
        BioLab.Dict.merge(
            Dict(
                "polar" => Dict(
                    "angularaxis" => BioLab.Dict.merge(
                        axis,
                        Dict(
                            "direction" => "clockwise",
                            "tickfont" => Dict("size" => 32, "family" => "Optima"),
                        ),
                        BioLab.Dict.set_with_last!,
                    ),
                    "radialaxis" => BioLab.Dict.merge(
                        axis,
                        Dict(
                            "nticks" => 8,
                            "tickfont" => Dict("size" => 16, "family" => "Monospace"),
                        ),
                        BioLab.Dict.set_with_last!,
                    ),
                ),
                "title" => Dict(
                    "text" => "Radar",
                    "x" => 0.01,
                    "font" => Dict(
                        "size" => 48,
                        "family" => "Times New Roman",
                        "color" => "#27221f",
                    ),
                ),
            ),
            layout,
            BioLab.Dict.set_with_last!,
        );
        ke_ar...,
    )

end

end
