module Evidence

using GLM: @formula, Binomial, coef, glm, predict

using ..Nucleus

function fit(ta_, f1_)

    glm(@formula(ta_ ~ f1_), (; ta_, f1_), Binomial())

end

function plot(ht, ns, sa_, nt, ta_, nf, f1_, ge; marker_size = 4, layout = Dict{String, Any}())

    id_ = sortperm(f1_)

    sa_ = sa_[id_]

    ta_ = ta_[id_]

    f1_ = f1_[id_]

    mi, ma = Nucleus.Collection.get_minimum_maximum(f1_)

    pr_nu_ = predict(ge, (; f1_ = range(mi, ma, lastindex(sa_))); interval = :confidence)

    it, c1 = coef(ge)

    cr = -it / c1

    sl = 1 / c1

    Nucleus.Plot.plot(
        ht,
        [
            Dict(
                "type" => "heatmap",
                "x" => sa_,
                "z" => [ta_],
                "colorscale" => Nucleus.Color.fractionate(Nucleus.Color.COBI),
                "colorbar" => Dict(
                    "x" => 1,
                    "y" => 0,
                    "xanchor" => "left",
                    "yanchor" => "bottom",
                    "len" => 0.2,
                    "thickness" => 16,
                    "outlinecolor" => Nucleus.Color.HEFA,
                    "title" => Dict("text" => nt),
                    "tickvals" => (0, 1),
                ),
            ),
            Dict(
                "yaxis" => "y2",
                "x" => sa_,
                "y" => f1_,
                "mode" => "markers",
                "marker" => Dict("size" => marker_size, "color" => Nucleus.Color.HEBL),
                "cliponaxis" => false,
            ),
            Dict(
                "yaxis" => "y3",
                "x" => (sa_[1], sa_[end]),
                "y" => (0.5, 0.5),
                "mode" => "lines",
                "line" => Dict("color" => Nucleus.Color.HEFA),
            ),
            Dict(
                "yaxis" => "y3",
                "x" => sa_,
                "y" => pr_nu_.prediction,
                "marker" => Dict("size" => marker_size * 0.8, "color" => Nucleus.Color.HERE),
                "cliponaxis" => false,
            ),
            Dict(
                "yaxis" => "y3",
                "x" => sa_,
                "y" => pr_nu_.lower,
                "mode" => "lines",
                "line" => Dict("width" => 0),
            ),
            Dict(
                "yaxis" => "y3",
                "x" => sa_,
                "y" => pr_nu_.upper,
                "mode" => "lines",
                "line" => Dict("width" => 0),
                "fill" => "tonexty",
                "fillcolor" => Nucleus.Color.add_alpha(Nucleus.Color.HERE, 0.16),
            ),
        ],
        Nucleus.Dict.merge(
            Dict(
                "showlegend" => false,
                "xaxis" => Dict("domain" => (0.08, 1), "title" => Dict("text" => ns)),
                "yaxis" => Dict("domain" => (0, 0.04), "tickvals" => ()),
                "yaxis2" => Dict(
                    "domain" => (0.08, 1),
                    "position" => 0,
                    "title" =>
                        Dict("text" => nf, "font" => Dict("color" => Nucleus.Color.HEBL)),
                    "range" => (mi, ma),
                    "tickvals" => Nucleus.Plot.set_tickvals(f1_),
                    "zeroline" => false,
                    "showgrid" => false,
                ),
                "yaxis3" => Dict(
                    "domain" => (0.08, 1),
                    "position" => 0.08,
                    "overlaying" => "y2",
                    "title" => Dict(
                        "text" => "Probability of $nt",
                        "font" => Dict("color" => Nucleus.Color.HERE),
                    ),
                    "range" => (0, 1),
                    "dtick" => 0.1,
                    "zeroline" => false,
                    "showgrid" => false,
                ),
                "annotations" => [
                    Dict(
                        "yref" => "y3",
                        "x" => sa_[argmin(abs.(pr_nu_.prediction .- 0.5))],
                        "y" => 0.5,
                        "text" => "$nf $(round(cr; sigdigits = 2))<br>Slope $(round(sl; sigdigits = 2))",
                        "arrowhead" => 6,
                    ),
                ],
            ),
            layout,
        ),
    )

end

end
