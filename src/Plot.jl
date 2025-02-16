module Plot

using JSON: json

using ..Omics

function plot(fi, tr_, la = Dict{String, Any}(), co = Dict{String, Any}())

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
        fi,
        ("https://cdn.plot.ly/plotly-2.35.2.min.js",),
        id,
        """
        Plotly.newPlot("$id", $(json(tr_)), $(json(la)), $(json(co)))""",
    )

end

const _CO = Omics.Coloring.fractionate(("#0000ff", "#ffffff", "#ff0000"))

const LA = Dict("yaxis" => Dict("autorange" => "reversed"))

function tick(it_::AbstractArray{<:Integer})

    extrema(it_)

end

function tick(fl_)

    mi, ma = extrema(fl_)

    mi, sum(fl_) / lastindex(fl_), ma

end

function plot_heat_map(fi, nu; yc_ = (), xc_ = (), co = _CO, la = Dict{String, Any}())

    plot(
        fi,
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
    fi,
    n1,
    n2;
    yc_ = map(id -> "$id ●", axes(n1, 1)),
    xc_ = map(id -> "● $id", axes(n1, 2)),
    co = _CO,
    la = Dict{String, Any}(),
)

    id_ = vec(CartesianIndices(n1))

    plot(
        fi,
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
    fi,
    an___,
    ra___;
    na_ = eachindex(an___),
    co_ = Omics.Coloring.I2_,
    il_ = fill("toself", lastindex(an___)),
    la = Dict{String, Any}(),
)

    wi = 2

    hd = "#000000"

    hf = Omics.Color.LI

    plot(
        fi,
        [
            Dict(
                "type" => "scatterpolar",
                "name" => na_[id],
                "theta" => vcat(an___[id], an___[id][1]),
                "r" => vcat(ra___[id], ra___[id][1]),
                "mode" => "lines",
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 4,
                    "color" => co_[id],
                ),
                "fill" => il_[id],
                "fillcolor" => co_[id],
            ) for id in eachindex(an___)
        ],
        Omics.Dic.merg(
            Dict(
                "title" => Dict("x" => 0.008, "font" => Dict("size" => 32)),
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => wi,
                        "linecolor" => hd,
                        "ticklen" => 16,
                        "tickwidth" => wi,
                        "tickcolor" => hd,
                        "tickfont" => Dict("size" => 24),
                        "gridwidth" => wi,
                        "gridcolor" => hf,
                    ),
                    "radialaxis" => Dict(
                        "linewidth" => wi,
                        "linecolor" => hd,
                        "ticklen" => 8,
                        "tickwidth" => wi,
                        "tickcolor" => hd,
                        "tickfont" => Dict("size" => 16),
                        "gridwidth" => wi,
                        "gridcolor" => hf,
                    ),
                ),
            ),
            la,
        ),
    )

end

end
