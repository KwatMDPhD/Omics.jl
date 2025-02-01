module ErrorMatrix

using ..Omics

function make()

    Matrix{Int}(undef, 2, 2)

end

function fil!(er, la_, pr_, th)

    for id in eachindex(la_)

        er[la_[id], pr_[id] < th ? 1 : 2] += 1

    end

end

function summarize(er, to = sum(er))

    tn, fn, fp, tp = er

    an = tn + fp

    ap = fn + tp

    tn / an, fn / ap, fp / an, tp / ap, tn / (tn + fn), tp / (tp + fp), (tn + tp) / to

end

function _make_axis(te)

    Dict("title" => Dict("text" => te), "tickfont" => Dict("size" => Omics.Plot.S1))

end

function _make_annotation(yc, xc, te)

    Dict(
        "y" => yc,
        "x" => xc,
        "text" => te,
        "font" => Dict("size" => Omics.Plot.S2),
        "showarrow" => false,
    )

end

function plot(
    ht,
    er,
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
        er;
        ro_,
        co_,
        cl = Omics.Palette.fractionate(Omics.Palette.make(("#ffffff", Omics.Color.VI))),
        la = Omics.Dic.merge(
            Dict(
                "title" => Dict("text" => "Error Matrix"),
                "yaxis" => _make_axis("Actual"),
                "xaxis" => _make_axis("Predicted"),
                "annotations" => (
                    _make_annotation(
                        ro_[1],
                        co_[1],
                        "$(er[1, 1])<br>TNR (Specificity) $(Omics.Numbe.shorten(tn))",
                    ),
                    _make_annotation(
                        ro_[2],
                        co_[1],
                        "$(er[2, 1])<br>FNR (Type-2 Error) $(Omics.Numbe.shorten(fn))",
                    ),
                    _make_annotation(
                        ro_[1],
                        co_[2],
                        "$(er[1, 2])<br>FPR (Type-1 Error) $(Omics.Numbe.shorten(fp))",
                    ),
                    _make_annotation(
                        ro_[2],
                        co_[2],
                        "$(er[2, 2])<br>TPR (Sensitivity or Recall) $(Omics.Numbe.shorten(tp))",
                    ),
                    _make_annotation(0.5, 0, "NPV $(Omics.Numbe.shorten(np))"),
                    _make_annotation(0.5, 1, "PPV (Precision) $(Omics.Numbe.shorten(pp))"),
                    _make_annotation(0.5, 0.5, "Accuracy $(Omics.Numbe.shorten(ac))"),
                ),
            ),
            la,
        ),
    )

end

end
