module Plot

using JSON: json

using ..Omics

function plot(ht, tr_, la = Dict{String, Any}(), co = Dict{String, Any}())

    he = 832

    la = Omics.Dic.merg(
        Dict(
            "height" => he,
            "width" => he * MathConstants.golden,
            "title" => Dict("font" => Dict("size" => 32)),
        ),
        la,
    )

    co["displaylogo"] = false

    for (ke, va) in la

        if startswith(ke, r"[xy]axis")

            la[ke] = Omics.Dic.merg(
                Dict(
                    "automargin" => true,
                    "title" => Dict("font" => Dict("size" => 24)),
                    "zeroline" => false,
                    "showgrid" => false,
                ),
                va,
            )

        end

    end

    id = "pl"

    Omics.HTM.writ(
        ht,
        ("https://cdn.plot.ly/plotly-2.35.2.min.js",),
        id,
        """
        Plotly.newPlot("$id", $(json(tr_)), $(json(la)), $(json(co)))""",
    )

end

function tick(nu_::AbstractArray{<:Integer})

    extrema(nu_)

end

function tick(nu_)

    mi, ma = extrema(nu_)

    mi, sum(nu_) / lastindex(nu_), ma

end

const CO = Omics.Coloring.fractionate(("#0000ff", "#ffffff", "#ff0000"))

const LA = Dict("yaxis" => Dict("autorange" => "reversed"))

function plot_heat_map(ht, nu; yc_ = (), xc_ = (), co = CO, la = Dict{String, Any}())

    plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "y" => yc_,
                "x" => xc_,
                "z" => collect(eachrow(nu)),
                "colorscale" => co,
                "colorbar" => Dict(
                    "len" => 0.56,
                    "thickness" => 16,
                    "tickvals" => tick(filter(!isnan, nu)),
                    "tickfont" => Dict("size" => 16),
                ),
            ),
        ),
        Omics.Dic.merg(LA, la),
    )

end

function plot_bubble_map(
    ht,
    n1,
    n2;
    yc_ = map(id -> "$id ●", axes(n1, 1)),
    xc_ = map(id -> "● $id", axes(n1, 2)),
    co = CO,
    la = Dict{String, Any}(),
)

    id_ = vec(CartesianIndices(n1))

    plot(
        ht,
        (
            Dict(
                "y" => map(id -> yc_[id[1]], id_),
                "x" => map(id -> xc_[id[2]], id_),
                "mode" => "markers",
                "marker" => Dict("size" => vec(n1), "color" => vec(n2), "colorscale" => co),
            ),
        ),
        Omics.Dic.merg(LA, la),
    )

end

function plot_radar(
    ht,
    an___,
    ra___;
    na_ = eachindex(an___),
    c1_ = Omics.Coloring.I2_,
    fi_ = fill("toself", lastindex(an___)),
    la = Dict{String, Any}(),
)

    wi = 2

    c2 = "#000000"

    c3 = Omics.Color.LI

    plot(
        ht,
        map(
            id -> Dict(
                "type" => "scatterpolar",
                "name" => na_[id],
                "theta" => vcat(an___[id], an___[id][1]),
                "r" => vcat(ra___[id], ra___[id][1]),
                "mode" => "lines",
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 4,
                    "color" => c1_[id],
                ),
                "fill" => fi_[id],
                "fillcolor" => c1_[id],
            ),
            eachindex(an___),
        ),
        Omics.Dic.merg(
            Dict(
                "title" => Dict("x" => 0.008, "font" => Dict("size" => 32)),
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => wi,
                        "linecolor" => c2,
                        "ticklen" => 16,
                        "tickwidth" => wi,
                        "tickcolor" => c2,
                        "tickfont" => Dict("size" => 24),
                        "gridwidth" => wi,
                        "gridcolor" => c3,
                    ),
                    "radialaxis" => Dict(
                        "linewidth" => wi,
                        "linecolor" => c2,
                        "ticklen" => 8,
                        "tickwidth" => wi,
                        "tickcolor" => c2,
                        "tickfont" => Dict("size" => 16),
                        "gridwidth" => wi,
                        "gridcolor" => c3,
                    ),
                ),
            ),
            la,
        ),
    )

end

end
