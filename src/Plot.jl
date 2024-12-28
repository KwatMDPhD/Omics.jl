module Plot

using JSON: json

using Random: randstring

using ..Omics

const SS = 832

const SL = SS * MathConstants.golden

const S1 = 32

const S2 = 24

const S3 = 16

function rang(mi, ma, ex)

    ex *= ma - mi

    mi - ex, ma + ex

end

function tick(it_::AbstractArray{<:Integer})

    extrema(it_)

end

function tick(fl_)

    mi, ma = extrema(fl_)

    mi, sum(fl_) / lastindex(fl_), ma

end

function plot(ht, da_, la = Dict{String, Any}(), co = Dict{String, Any}())

    if isempty(ht)

        ht = joinpath(tempdir(), "$(randstring()).html")

    end

    la = Omics.Dic.merg(
        Dict(
            "height" => SS,
            "width" => SL,
            "title" => Dict("font" => Dict("size" => S1)),
            "hovermode" => "closest",
        ),
        la,
    )

    co = Omics.Dic.merg(Dict("displaylogo" => false), co)

    for (ke, va) in la

        if startswith(ke, r"[xy]axis")

            la[ke] = Omics.Dic.merg(
                Dict(
                    "automargin" => true,
                    "title" => Dict("font" => Dict("size" => S2)),
                    "zeroline" => false,
                    "showgrid" => false,
                ),
                va,
            )

        end

    end

    id = "pl"

    Omics.Path.ope(
        Omics.HTM.writ(
            ht,
            ("https://cdn.plot.ly/plotly-2.35.2.min.js",),
            id,
            "Plotly.newPlot(\"$id\", $(json(da_)), $(json(la)), $(json(co)))",
        ),
    )

end

const _CO = Omics.Palette.fractionate(Omics.Palette.bwr)

function plot_heat_map(ht, nu; ro_ = (), co_ = (), cl = _CO, la = Dict{String, Any}())

    plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "y" => ro_,
                "x" => co_,
                "z" => collect(eachrow(nu)),
                "colorscale" => cl,
                "colorbar" => Dict(
                    "len" => 0.56,
                    "thickness" => 16,
                    "tickvals" => tick(filter(!isnan, nu)),
                    "tickfont" => Dict("size" => S3),
                ),
            ),
        ),
        Omics.Dic.merg(Dict("yaxis" => Dict("autorange" => "reversed")), la),
    )

end

function plot_bubble_map(
    ht,
    ns,
    nc;
    ro_ = map(id -> "$id ●", axes(ns, 1)),
    co_ = map(id -> "● $id", axes(ns, 2)),
    cl = _CO,
    la = Dict{String, Any}(),
)

    id_ = vec(CartesianIndices(ns))

    plot(
        ht,
        (
            Dict(
                "y" => map(id -> ro_[id[1]], id_),
                "x" => map(id -> co_[id[2]], id_),
                "mode" => "markers",
                "marker" => Dict("size" => vec(ns), "color" => vec(nc), "colorscale" => cl),
            ),
        ),
        Omics.Dic.merg(
            Dict(
                "yaxis" => Dict("autorange" => "reversed"),
                "xaxis" => Dict{String, Any}(),
            ),
            la,
        ),
    )

end

function plot_radar(
    ht,
    an_,
    ra_;
    na_ = eachindex(an_),
    sh_ = trues(lastindex(an_)),
    he_ = Omics.Palette.HE_,
    fi_ = fill("toself", lastindex(an_)),
    ma = 1.08 * maximum(Iterators.flatten(ra_)),
    la = Dict{String, Any}(),
)

    wi = 2

    hd = "#000000"

    hf = Omics.Color.LI

    plot(
        ht,
        [
            Dict(
                "type" => "scatterpolar",
                "name" => na_[id],
                "showlegend" => sh_[id],
                "theta" => vcat(an_[id], an_[id][1]),
                "r" => vcat(ra_[id], ra_[id][1]),
                "mode" => "lines",
                "line" => Dict(
                    "shape" => "spline",
                    "smoothing" => 0,
                    "width" => 4,
                    "color" => he_[id],
                ),
                "fill" => fi_[id],
                "fillcolor" => he_[id],
            ) for id in eachindex(an_)
        ],
        Omics.Dic.merg(
            Dict(
                "title" => Dict("x" => 0.008, "font" => Dict("size" => S1)),
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => wi,
                        "linecolor" => hd,
                        "ticklen" => 16,
                        "tickwidth" => wi,
                        "tickcolor" => hd,
                        "tickfont" => Dict("size" => S2),
                        "gridwidth" => wi,
                        "gridcolor" => hf,
                    ),
                    "radialaxis" => Dict(
                        "range" => (0.0, ma),
                        "linewidth" => wi,
                        "linecolor" => hd,
                        "ticklen" => 8,
                        "tickwidth" => wi,
                        "tickcolor" => hd,
                        "tickfont" => Dict("size" => S3),
                        "gridwidth" => wi,
                        "gridcolor" => hf,
                    ),
                ),
            ),
            la,
        ),
    )

end

function animate(gi, pn_)

    run(`magick -delay 32 $pn_ $gi`)

    Omics.Path.ope(gi)

end

end
