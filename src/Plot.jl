module Plot

using JSON: json

using Printf: @sprintf

using Random: randstring

using LeMoColor

using LeMoHTML

function _open(pa)

    try

        run(`open --background $pa`)

    catch

        @warn "Could not open $pa."

    end

end

function animate(gi, pn_)

    run(`magick -delay 32 -loop 0 $pn_ $gi`)

    _open(gi)

end

const SI = 832

function shorten(nu)

    @sprintf "%.2g" nu

end

function _merge(k1_v1, k2_v2)

    ke_va = Dict{String, Any}()

    for ke in union(keys(k1_v1), keys(k2_v2))

        ke_va[ke] = if haskey(k1_v1, ke) && haskey(k2_v2, ke)

            v1 = k1_v1[ke]

            v2 = k2_v2[ke]

            v1 isa AbstractDict && v2 isa AbstractDict ? _merge(v1, v2) : v2

        elseif haskey(k1_v1, ke)

            k1_v1[ke]

        else

            k2_v2[ke]

        end

    end

    ke_va

end

function plot(ht, da, la = Dict{String, Any}(), co = Dict{String, Any}())

    if isempty(ht)

        ht = joinpath(tempdir(), "$(randstring()).html")

    end

    la = _merge(
        Dict(
            "height" => SI,
            "width" => SI * 1.618,
            "title" => Dict("font" => Dict("size" => 32)),
            "hovermode" => "closest",
        ),
        la,
    )

    for (ke, va) in la

        if contains(ke, r"^[xy]axis")

            la[ke] = _merge(
                Dict(
                    "automargin" => true,
                    "title" => Dict("font" => Dict("size" => 20)),
                    "zeroline" => false,
                    "showgrid" => false,
                ),
                va,
            )

        end

    end

    _open(
        LeMoHTML.write(
            ht,
            ("https://cdn.plot.ly/plotly-latest.min.js",),
            "Plotly.newPlot(\"Plotly\", $(json(da)), $(json(la)), $(json(merge(Dict("displaylogo" => false), co))))";
            id = "Plotly",
        ),
    )

end

function _label_1(nu)

    "$nu ●"

end

function _label_2(nu)

    "● $nu"

end

function make_tickvals(nu_)

    mi, ma = extrema(nu_)

    all(isinteger, nu_) ? (mi:ma) :
    [shorten(mi), shorten(sum(nu_) / lastindex(nu_)), shorten(ma)]

end

function plot_heat_map(
    ht,
    zc;
    ro_ = map(_label_1, axes(zc, 1)),
    co_ = map(_label_2, axes(zc, 2)),
    co = LeMoColor.pick(zc),
    la = Dict{String, Any}(),
)

    plot(
        ht,
        [
            Dict(
                "type" => "heatmap",
                "y" => ro_,
                "x" => co_,
                "z" => collect(eachrow(zc)),
                "colorscale" => LeMoColor.fractionate(co),
                "colorbar" => Dict(
                    "len" => 0.4,
                    "thickness" => 16,
                    "tickvals" => make_tickvals(filter(!isnan, zc)),
                    "tickfont" => Dict("family" => "Monospace", "size" => 16),
                ),
            ),
        ],
        _merge(Dict("yaxis" => Dict("autorange" => "reversed")), la),
    )

end

function plot_bubble_map(
    ht,
    zs,
    zc;
    ro_ = map(_label_1, axes(zs, 1)),
    co_ = map(_label_2, axes(zs, 2)),
    co = LeMoColor.pick(zc),
    la = Dict{String, Any}(),
)

    ca_ = vec(CartesianIndices(zs))

    plot(
        ht,
        [
            Dict(
                "y" => map(ca -> ro_[ca[1]], ca_),
                "x" => map(ca -> co_[ca[2]], ca_),
                "mode" => "markers",
                "marker" => Dict(
                    "size" => vec(zs),
                    "color" => vec(zc),
                    "colorscale" => LeMoColor.fractionate(co),
                ),
            ),
        ],
        _merge(
            Dict(
                "yaxis" => Dict("autorange" => "reversed"),
                "xaxis" => Dict{String, Any}(),
            ),
            la,
        ),
    )

end

function _tie(an_)

    vcat(an_, an_[1])

end

function plot_radar(
    ht,
    an_,
    ra_;
    na_ = eachindex(x_),
    sh_ = trues(lastindex(an_)),
    cl_ = LeMoColor.color(eachindex(an_)),
    fi_ = fill("toself", lastindex(an_)),
    cf_ = cl_,
    la = Dict{String, Any}(),
)

    wi = 2

    c1 = "#351e1c"

    c2 = LeMoColor.FA

    c3 = "#2e211b"

    plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "legendgroup" => id,
                "name" => na_[id],
                "showlegend" => sh_[id],
                "theta" => _tie(an_[id]),
                "r" => _tie(ra_[id]),
                "mode" => "lines",
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 4,
                    "color" => cl_[id],
                ),
                "fill" => fi_[id],
                "fillcolor" => cf_[id],
            ) for id in eachindex(ra_)
        ],
        _merge(
            Dict(
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => wi,
                        "linecolor" => c1,
                        "ticklen" => 16,
                        "tickwidth" => wi,
                        "tickcolor" => c1,
                        "tickfont" =>
                            Dict("family" => "Optima", "size" => 24, "color" => c3),
                        "gridwidth" => wi,
                        "gridcolor" => c2,
                    ),
                    "radialaxis" => Dict(
                        "range" => (0, 1.08 * maximum(Iterators.flatten(ra_))),
                        "linewidth" => wi,
                        "linecolor" => c1,
                        "ticklen" => 8,
                        "tickwidth" => wi,
                        "tickcolor" => c1,
                        "tickfont" => Dict(
                            "family" => "Monospace",
                            "size" => 12,
                            "color" => c3,
                        ),
                        "gridwidth" => wi,
                        "gridcolor" => c2,
                    ),
                ),
                "title" => Dict(
                    "x" => 0.008,
                    "font" => Dict("family" => "Times New Roman", "color" => "#27221f"),
                ),
            ),
            la,
        ),
    )

end

end
