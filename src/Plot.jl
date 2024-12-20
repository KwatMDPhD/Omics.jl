module Plot

using JSON: json

using Random: randstring

using ..Omics

const SS = 832

const SL = SS * 1.618

function rang(mi, ma, ex)

    ex *= ma - mi

    mi - ex, ma + ex

end

function plot(ht, da, la = Dict{String, Any}(), co = Dict{String, Any}())

    if isempty(ht)

        ht = joinpath(tempdir(), "$(randstring()).html")

    end

    la = Omics.Dic.merg(
        Dict(
            "height" => SS,
            "width" => SL,
            "title" => Dict("font" => Dict("size" => 32)),
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
                    "title" => Dict("font" => Dict("size" => 24)),
                    "zeroline" => false,
                    "showgrid" => false,
                ),
                va,
            )

        end

    end

    Omics.Path.ope(
        Omics.HTM.writ(
            ht,
            ("https://cdn.plot.ly/plotly-2.35.2.min.js",),
            "Plotly.newPlot(\"wr\", $(json(da)), $(json(la)), $(json(co)))",
        ),
    )

end

function _label_1(nu)

    "$nu ●"

end

function _label_2(nu)

    "● $nu"

end

const _CL = Omics.Palette.fractionate(Omics.Palette.bwr)

function make_tickvals(nu_)

    mi, ma = extrema(nu_)

    me = sum(nu_) / lastindex(nu_)

    all(isinteger, nu_) ? Tuple(mi:ma) : (mi, me, ma)

end

function plot_heat_map(
    ht,
    ma;
    ro_ = map(_label_1, axes(ma, 1)),
    co_ = map(_label_2, axes(ma, 2)),
    cl = _CL,
    la = Dict{String, Any}(),
)

    plot(
        ht,
        (
            Dict(
                "type" => "heatmap",
                "y" => ro_,
                "x" => co_,
                "z" => collect(eachrow(ma)),
                "colorscale" => cl,
                "colorbar" => Dict(
                    "len" => 0.56,
                    "thickness" => 16,
                    "tickvals" => make_tickvals(filter(!isnan, ma)),
                    "tickfont" => Dict("family" => "Monospace", "size" => 16),
                ),
            ),
        ),
        Omics.Dic.merg(Dict("yaxis" => Dict("autorange" => "reversed")), la),
    )

end

function plot_bubble_map(
    ht,
    ma,
    mc;
    ro_ = map(_label_1, axes(ma, 1)),
    co_ = map(_label_2, axes(ma, 2)),
    cl = _CL,
    la = Dict{String, Any}(),
)

    id_ = vec(CartesianIndices(ma))

    plot(
        ht,
        (
            Dict(
                "y" => map(id -> ro_[id[1]], id_),
                "x" => map(id -> co_[id[2]], id_),
                "mode" => "markers",
                "marker" => Dict("size" => vec(ma), "color" => vec(mc), "colorscale" => cl),
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
            ) for id in eachindex(ra_)
        ],
        Omics.Dic.merg(
            Dict(
                "polar" => Dict(
                    "angularaxis" => Dict(
                        "direction" => "clockwise",
                        "linewidth" => wi,
                        "linecolor" => hd,
                        "ticklen" => 16,
                        "tickwidth" => wi,
                        "tickcolor" => hd,
                        "tickfont" => Dict("family" => "Optima", "size" => 24),
                        "gridwidth" => wi,
                        "gridcolor" => hf,
                    ),
                    "radialaxis" => Dict(
                        "range" => (0, 1.08 * maximum(Iterators.flatten(ra_))),
                        "linewidth" => wi,
                        "linecolor" => hd,
                        "ticklen" => 8,
                        "tickwidth" => wi,
                        "tickcolor" => hd,
                        "tickfont" => Dict("family" => "Monospace", "size" => 16),
                        "gridwidth" => wi,
                        "gridcolor" => hf,
                    ),
                ),
                "title" =>
                    Dict("x" => 0.008, "font" => Dict("family" => "Times New Roman")),
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
