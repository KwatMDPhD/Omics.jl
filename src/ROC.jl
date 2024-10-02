module ROC

using LeMoColor

using Plot

function make_matrix()

    Matrix{UInt16}(undef, 2, 2)

end

function fill_matrix!(ma, la_, pr_, th)

    for id in eachindex(la_)

        ma[la_[id], pr_[id] < th ? 1 : 2] += 1

    end

end

function summarize_matrix(ma, to = sum(ma))

    tn, fn, fp, tp = ma

    an = tn + fp

    ap = fn + tp

    tn / an, fn / ap, fp / an, tp / ap, tn / (tn + fn), tp / (tp + fp), (tn + tp) / to

end

function _make_axis(te)

    Dict("title" => Dict("text" => te), "tickfont" => Dict("size" => 40))

end

function _make_annotation(yc, xc, te)

    Dict(
        "y" => yc,
        "x" => xc,
        "showarrow" => false,
        "text" => te,
        "font" => Dict("family" => "Monospace", "size" => 24, "color" => "#000000"),
    )

end

function plot_matrix(
    ht,
    ma,
    tn,
    fn,
    fp,
    tp,
    np,
    pp,
    ac;
    ro_ = ("😵", "😊"),
    co_ = ("👎 ", "👍"),
    la = Dict{String, Any}(),
)

    Plot.plot_heat_map(
        ht,
        ma;
        ro_ = ro_,
        co_ = co_,
        co = LeMoColor.make(["#ffffff", LeMoColor.GR]),
        la = Plot._merge(
            Dict(
                "title" => Dict("text" => "Confusion Matrix"),
                "yaxis" => _make_axis("Actual"),
                "xaxis" => _make_axis("Predicted"),
                "annotations" => (
                    _make_annotation(
                        ro_[1],
                        co_[1],
                        "$(ma[1, 1])<br>TNR (Specificity) $(Plot.shorten(tn))",
                    ),
                    _make_annotation(
                        ro_[2],
                        co_[1],
                        "$(ma[2, 1])<br>FNR (Type-2 Error) $(Plot.shorten(fn))",
                    ),
                    _make_annotation(
                        ro_[1],
                        co_[2],
                        "$(ma[1, 2])<br>FPR (Type-1 Error) $(Plot.shorten(fp))",
                    ),
                    _make_annotation(
                        ro_[2],
                        co_[2],
                        "$(ma[2, 2])<br>TPR (Sensitivity or Recall) $(Plot.shorten(tp))",
                    ),
                    _make_annotation(0.5, 0, "NPV $(Plot.shorten(np))"),
                    _make_annotation(0.5, 1, "PPV (Precision) $(Plot.shorten(pp))"),
                    _make_annotation(0.5, 0.5, "Accuracy $(Plot.shorten(ac))"),
                ),
            ),
            la,
        ),
    )

end

function make_line(la_, pr_, th_ = range(extrema(pr_)..., 10))

    ut = lastindex(th_)

    fp_ = Vector{Float64}(undef, ut)

    tp_ = Vector{Float64}(undef, ut)

    ma = make_matrix()

    to = lastindex(la_)

    for it in 1:ut

        th = th_[it]

        fill!(ma, 0)

        fill_matrix!(ma, la_, pr_, th)

        tn, fn, fp, tp, np, pp, ac = summarize_matrix(ma, to)

        plot_matrix(
            "",
            ma,
            tn,
            fn,
            fp,
            tp,
            np,
            pp,
            ac;
            la = Dict("title" => Dict("text" => "Threshold $(Plot.shorten(th))")),
        )

        fp_[it] = fp

        tp_[it] = tp

    end

    fp_, tp_

end

function plot_line(ht, fp_, tp_)

    id = sortperm(fp_)

    wi = 4

    co = LeMoColor.BL

    ra = -0.02, 1.02

    Plot.plot(
        ht,
        (
            Dict(
                "name" => "Random",
                "y" => (0, 1),
                "x" => (0, 1),
                "mode" => "lines",
                "line" => Dict("width" => wi, "color" => "#000000"),
            ),
            Dict(
                # TODO: Correct AUC calculation.
                "name" => "Area = $(Plot.shorten(sum(tp_) / lastindex(tp_)))",
                "y" => [0; tp_[id]],
                "x" => [0; fp_[id]],
                "mode" => "markers+lines",
                "marker" => Dict("size" => wi * 2.4, "color" => co),
                "line" => Dict("width" => wi, "color" => co),
                "fill" => "tozeroy",
                "fillcolor" => LeMoColor.fade(co, 0.4),
            ),
        ),
        Dict(
            "title" => Dict("text" => "Receiver Operating Characteristic"),
            "yaxis" => Dict("range" => ra, "title" => Dict("text" => "True-Positive Rate")),
            "xaxis" =>
                Dict("range" => ra, "title" => Dict("text" => "False-Positive Rate")),
            "legend" => Dict(
                "y" => 0.04,
                "x" => 0.968,
                "yanchor" => "bottom",
                "xanchor" => "right",
            ),
        ),
    )

end

end
