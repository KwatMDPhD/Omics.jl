module ROC

using ..Omics

function make_matrix()

    Matrix{UInt}(undef, 2, 2)

end

function fill_matrix!(ma, la_, pr_, th)

    for id in eachindex(la_)

        ma[la_[id], pr_[id] < th ? 1 : 2] += one(UInt)

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
        "showarrow" => false,
        "y" => yc,
        "x" => xc,
        "text" => te,
        "font" => Dict("family" => "Monospace", "size" => 24),
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

    Omics.Plot.plot_heat_map(
        ht,
        ma;
        ro_,
        co_,
        cl = Omics.Palette.fractionate(Omics.Palette.make(("#ffffff", Omics.Color.GR))),
        la = Omics.Dic.merge(
            Dict(
                "title" => Dict("text" => "Confusion Matrix"),
                "yaxis" => _make_axis("Actual"),
                "xaxis" => _make_axis("Predicted"),
                "annotations" => (
                    _make_annotation(
                        ro_[1],
                        co_[1],
                        "$(ma[1, 1])<br>TNR (Specificity) $(Omics.Strin.shorten(tn))",
                    ),
                    _make_annotation(
                        ro_[2],
                        co_[1],
                        "$(ma[2, 1])<br>FNR (Type-2 Error) $(Omics.Strin.shorten(fn))",
                    ),
                    _make_annotation(
                        ro_[1],
                        co_[2],
                        "$(ma[1, 2])<br>FPR (Type-1 Error) $(Omics.Strin.shorten(fp))",
                    ),
                    _make_annotation(
                        ro_[2],
                        co_[2],
                        "$(ma[2, 2])<br>TPR (Sensitivity or Recall) $(Omics.Strin.shorten(tp))",
                    ),
                    _make_annotation(0.5, 0, "NPV $(Omics.Strin.shorten(np))"),
                    _make_annotation(0.5, 1, "PPV (Precision) $(Omics.Strin.shorten(pp))"),
                    _make_annotation(0.5, 0.5, "Accuracy $(Omics.Strin.shorten(ac))"),
                ),
            ),
            la,
        ),
    )

end

function make_line(la_, pr_, th_ = Omics.Grid.make(pr_, 10))

    ut = lastindex(th_)

    fp_ = Vector{Float64}(undef, ut)

    tp_ = Vector{Float64}(undef, ut)

    ma = make_matrix()

    to = lastindex(la_)

    for it in 1:ut

        th = th_[it]

        fill!(ma, zero(UInt))

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
            la = Dict("title" => Dict("text" => "Threshold $(Omics.Strin.shorten(th))")),
        )

        fp_[it] = fp

        tp_[it] = tp

    end

    fp_, tp_

end

function plot_line(ht, fp_, tp_)

    id = sortperm(fp_)

    wi = 2

    co = Omics.Color.BL

    ra = -0.02, 1.02

    Omics.Plot.plot(
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
                # TODO: Check
                "name" => "Area = $(Omics.Strin.shorten(sum(tp_) / lastindex(tp_)))",
                "y" => [0; tp_[id]],
                "x" => [0; fp_[id]],
                "mode" => "markers+lines",
                "marker" => Dict("size" => wi * 2.4, "color" => co),
                "line" => Dict("width" => wi, "color" => co),
                "fill" => "tozeroy",
                "fillcolor" => Omics.Color.hexify(co, 0.4),
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
