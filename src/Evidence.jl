module Evidence

using GLM: @formula, Binomial, coef, fitted, glm, predict

using ..Nucleus

function fit(ta_, f1_)

    glm(@formula(ta_ ~ f1_), (; ta_, f1_), Binomial())

end

function _get_evidence(P1_f1, P0, P1)

    log((P1_f1 / (1 - P1_f1)) / (P1 / P0))

end

function get_p0_p1(ta_)

    sum(iszero, ta_) / lastindex(ta_), sum(isone, ta_) / lastindex(ta_)

end

function plot_fit(ht, ns, sa_, nt, ta_, nf, f1_, ge; marker_size = 4)

    id_ = sortperm(f1_)

    sa_ = sa_[id_]

    ta_ = ta_[id_]

    f1_ = f1_[id_]

    it, c1 = coef(ge)

    cr = -it / c1

    sl = 1 / c1

    P1_fr__ = fitted(ge)

    P0, P1 = get_p0_p1(ta_)

    ab = 0

    for id in eachindex(sa_)

        ab += abs(_get_evidence(P1_fr__[id], P0, P1))

    end

    ev = sign(c1) * ab / lastindex(sa_)

    mi, ma = Nucleus.Collection.get_minimum_maximum(f1_)

    P1_fe__ = predict(ge, (; f1_ = range(mi, ma, lastindex(sa_))); interval = :confidence)

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
                "y" => P1_fe__.prediction,
                "marker" => Dict("size" => marker_size * 0.8, "color" => Nucleus.Color.HERE),
                "cliponaxis" => false,
            ),
            Dict(
                "yaxis" => "y3",
                "x" => sa_,
                "y" => P1_fe__.lower,
                "mode" => "lines",
                "line" => Dict("width" => 0),
            ),
            Dict(
                "yaxis" => "y3",
                "x" => sa_,
                "y" => P1_fe__.upper,
                "mode" => "lines",
                "line" => Dict("width" => 0),
                "fill" => "tonexty",
                "fillcolor" => Nucleus.Color.add_alpha(Nucleus.Color.HERE, 0.16),
            ),
        ],
        Dict(
            "showlegend" => false,
            "title" => Dict("text" => "Average Evidenve = $(round(ev; sigdigits = 2))"),
            "xaxis" => Dict("domain" => (0.08, 1), "title" => Dict("text" => ns)),
            "yaxis" => Dict("domain" => (0, 0.04), "tickvals" => ()),
            "yaxis2" => Dict(
                "domain" => (0.064, 1),
                "position" => 0,
                "title" => Dict("text" => nf, "font" => Dict("color" => Nucleus.Color.HEBL)),
                "range" => (mi, ma),
                "tickvals" => Nucleus.Plot.set_tickvals(f1_),
                "zeroline" => false,
                "showgrid" => false,
            ),
            "yaxis3" => Dict(
                "domain" => (0.064, 1),
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
                    "x" => sa_[argmin(abs.(P1_fe__.prediction .- 0.5))],
                    "y" => 0.5,
                    "text" => "$nf = $(round(cr; sigdigits = 2))<br>Slope = $(round(sl; sigdigits = 2))",
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
    te_;
    line_width = 2,
    marker_size = 24,
    textfont_size = 24,
    title_text = "Nomogram",
)

    P0, P1 = get_p0_p1(ge_[1].mf.data.ta_)

    be = log(P1 / P0)

    ev_ = Vector{Float64}(undef, lastindex(nf_))

    af = be

    for id in eachindex(nf_)

        af += ev_[id] = _get_evidence(predict(ge_[id], (; f1_ = [te_[id]]))[1], P0, P1)

    end

    be = _sign_square_root(be)

    ev_ .= _sign_square_root.(ev_)

    af = _sign_square_root(af)

    id = 0

    data = [
        Dict(
            "legendgroup" => id,
            "showlegend" => false,
            "y" => (id, id),
            "x" => (0, be),
            "mode" => "lines",
            "line" => Dict("width" => line_width, "color" => Nucleus.Color.HEDA),
        ),
        Dict(
            "legendgroup" => id,
            "name" => "Prior",
            "y" => (id,),
            "x" => (be,),
            "text" => round(be; sigdigits = 2),
            "mode" => "markers+text",
            "marker" => Dict(
                "size" => marker_size,
                "color" => be <= 0 ? Nucleus.Color.HESR : Nucleus.Color.HESG,
                "line" => Dict("width" => line_width * 1.6, "color" => Nucleus.Color.HEYE),
            ),
            "textposition" => be < 0 ? "left" : "right",
            "textfont" => Dict("size" => textfont_size),
        ),
    ]

    he_ = Nucleus.Color.color(eachindex(nf_))

    for id in eachindex(nf_)

        push!(
            data,
            Dict(
                "legendgroup" => id,
                "showlegend" => false,
                "y" => (id, id),
                "x" => (0, ev_[id]),
                "mode" => "lines",
                "line" => Dict("width" => line_width, "color" => he_[id]),
            ),
        )

        push!(
            data,
            Dict(
                "legendgroup" => id,
                "name" => nf_[id],
                "y" => (id,),
                "x" => (ev_[id],),
                "text" => "($(round(te_[id]; sigdigits = 2))) $(round(ev_[id]; sigdigits = 2))",
                "mode" => "markers+text",
                "marker" => Dict("size" => marker_size, "color" => he_[id]),
                "textposition" => ev_[id] < 0 ? "left" : "right",
                "textfont" => Dict("size" => textfont_size),
            ),
        )

    end

    id = lastindex(nf_) + 1

    push!(
        data,
        Dict(
            "legendgroup" => id,
            "showlegend" => false,
            "y" => (id, id),
            "x" => (0, af),
            "mode" => "lines",
            "line" => Dict("width" => line_width * 1.6, "color" => Nucleus.Color.HEDA),
        ),
    )

    push!(
        data,
        Dict(
            "legendgroup" => id,
            "name" => "Total",
            "y" => (id,),
            "x" => (af,),
            "text" => round(af; sigdigits = 2),
            "mode" => "markers+text",
            "marker" => Dict(
                "size" => marker_size * 1.6,
                "color" => af <= 0 ? Nucleus.Color.HESR : Nucleus.Color.HESG,
                "line" => Dict("width" => line_width * 1.6, "color" => Nucleus.Color.HEYE),
            ),
            "textposition" => af < 0 ? "left" : "right",
            "textfont" => Dict("size" => textfont_size),
        ),
    )

    Nucleus.Plot.plot(
        ht,
        data,
        Dict(
            "height" => 800,
            "width" => 800,
            "legend" => Dict("x" => 0, "y" => 0.5),
            "title" => Dict("text" => title_text, "font" => Dict("size" => textfont_size * 1.6)),
            "xaxis" => Dict(
                "range" => (-8, 8),
                "title" => Dict("text" => "√Evidence"),
                "dtick" => 1,
                "zeroline" => true,
                "zerolinewidth" => line_width * 2,
                "zerolinecolor" => Nucleus.Color.HEFA,
            ),
            "yaxis" => Dict("autorange" => "reversed", "visible" => false),
        ),
    )

end

end
