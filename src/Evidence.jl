module Evidence

using GLM: @formula, Binomial, coef, glm, predict

using ..Nucleus

function fit(ta_, f1_)

    glm(@formula(ta_ ~ f1_), (; ta_, f1_), Binomial())

end

function _get_evidence(P1_f1, P0, P1)

    log((P1_f1 / (1 - P1_f1)) / (P1 / P0))

end

function _average_evidence(ge, f1_)

    P1_f1__ = predict(ge, (; f1_))

    P0 = sum(iszero, ge.mf.data.ta_)

    P1 = sum(isone, ge.mf.data.ta_)

    ab = 0

    for id in eachindex(f1_)

        ab += abs(_get_evidence(P1_f1__[id], P0, P1))

    end

    sign(coef(ge)[2]) * ab / lastindex(f1_)

end

function plot_fit(ht, ns, sa_, nt, ta_, nf, f1_, ge; marker_size = 4)

    id_ = sortperm(f1_)

    sa_ = sa_[id_]

    ta_ = ta_[id_]

    f1_ = f1_[id_]

    mi, ma = Nucleus.Collection.get_minimum_maximum(f1_)

    P1_f1__ = predict(ge, (; f1_ = range(mi, ma, lastindex(sa_))); interval = :confidence)

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
                "y" => P1_f1__.prediction,
                "marker" => Dict("size" => marker_size * 0.8, "color" => Nucleus.Color.HERE),
                "cliponaxis" => false,
            ),
            Dict(
                "yaxis" => "y3",
                "x" => sa_,
                "y" => P1_f1__.lower,
                "mode" => "lines",
                "line" => Dict("width" => 0),
            ),
            Dict(
                "yaxis" => "y3",
                "x" => sa_,
                "y" => P1_f1__.upper,
                "mode" => "lines",
                "line" => Dict("width" => 0),
                "fill" => "tonexty",
                "fillcolor" => Nucleus.Color.add_alpha(Nucleus.Color.HERE, 0.16),
            ),
        ],
        Dict(
            "showlegend" => false,
            "title" => Dict(
                "text" => "Average Evidenve = $(round(_average_evidence(ge, f1_); sigdigits = 4))",
            ),
            "xaxis" => Dict("domain" => (0.08, 1), "title" => Dict("text" => ns)),
            "yaxis" => Dict("domain" => (0, 0.04), "tickvals" => ()),
            "yaxis2" => Dict(
                "domain" => (0.08, 1),
                "position" => 0,
                "title" => Dict("text" => nf, "font" => Dict("color" => Nucleus.Color.HEBL)),
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
                    "x" => sa_[argmin(abs.(P1_f1__.prediction .- 0.5))],
                    "y" => 0.5,
                    "text" => "$nf = $(round(cr; sigdigits = 4))<br>Slope = $(round(sl; sigdigits = 4))",
                    "arrowhead" => 6,
                ),
            ],
        ),
    )

end

function _sign_square_root(nu)

    sign(nu) * sqrt(abs(nu))

end

function plot_evidence(
    ht,
    nf_,
    ge_,
    f1_;
    line_width = 4,
    marker_size = 32,
    textfont_size = 24,
    title_text = "Nomogram",
)

    ev_ = Vector{Float64}(undef, lastindex(nf_))

    P0 = sum(iszero, ge_[1].mf.data.ta_)

    P1 = sum(isone, ge_[1].mf.data.ta_)

    po = _sign_square_root(log(P1 / P0))

    su = po

    for id in eachindex(nf_)

        su +=
            ev_[id] =
                _sign_square_root(_get_evidence(predict(ge_[id], (; f1_ = [f1_[id]]))[1], P0, P1))

    end

    pr = convert(Int, 0 < su)

    data = [
        Dict(
            "y" => ("Prior", "Prior"),
            "x" => (0, po),
            "mode" => "lines",
            "line" => Dict("width" => line_width, "color" => Nucleus.Color.HEDA),
        ),
        Dict(
            "y" => ("Prior",),
            "x" => (po,),
            "text" => round(po; sigdigits = 4),
            "mode" => "markers+text",
            "marker" => Dict("size" => marker_size, "color" => Nucleus.Color.HEDA),
            "textposition" => "top center",
            "textfont" => Dict("size" => textfont_size, "bgcolor" => "red"),
        ),
    ]

    he_ = Nucleus.Color.color(eachindex(nf_))

    for id in eachindex(nf_)

        push!(
            data,
            Dict(
                "y" => (nf_[id], nf_[id]),
                "x" => (0, ev_[id]),
                "mode" => "lines",
                "line" => Dict("width" => line_width * 0.64, "color" => he_[id]),
            ),
        )

        push!(
            data,
            Dict(
                "y" => (nf_[id],),
                "x" => (ev_[id],),
                "text" => "$(round(f1_[id]; sigdigits = 4)) ➡ $(round(ev_[id]; sigdigits = 4))",
                "mode" => "markers+text",
                "marker" => Dict("size" => marker_size * 0.64, "color" => he_[id]),
                "textposition" => "top center",
                "textfont" => Dict("size" => textfont_size),
                "cliponaxis" => false,
            ),
        )

    end

    push!(
        data,
        Dict(
            "y" => ("Total", "Total"),
            "x" => (0, su),
            "mode" => "lines",
            "line" => Dict("width" => line_width, "color" => Nucleus.Color.HEDA),
        ),
    )

    push!(
        data,
        Dict(
            "y" => ("Total",),
            "x" => (su,),
            "text" => "$(round(su; sigdigits = 4)) ➡ $pr",
            "mode" => "markers+text",
            "marker" => Dict(
                "size" => marker_size,
                "color" => isone(pr) ? Nucleus.Color.HEYE : Nucleus.Color.HEGR,
                "line" => Dict("width" => line_width, "color" => Nucleus.Color.HEDA),
            ),
            "textposition" => "top center",
            "textfont" => Dict("size" => textfont_size),
        ),
    )

    Nucleus.Plot.plot(
        ht,
        data,
        Dict(
            "showlegend" => false,
            "title" => Dict("text" => title_text, "font" => Dict("size" => textfont_size * 1.6)),
            "xaxis" => Dict(
                "range" => (-8, 8),
                "title" => Dict("text" => "√Evidence"),
                "dtick" => 1,
                "zeroline" => true,
                "zerolinewidth" => line_width * 0.4,
                "zerolinecolor" => Nucleus.Color.HEDA,
            ),
            "yaxis" => Dict("autorange" => "reversed", "ticktexts" => vcat(nf_, "Total")),
        ),
    )

end

end
