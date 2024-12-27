module ROC

using ..Omics

function make_line(la_, pr_, th_ = Omics.Grid.make(pr_, 10))

    ut = lastindex(th_)

    fp_ = Vector{Float64}(undef, ut)

    tp_ = Vector{Float64}(undef, ut)

    er = Omics.ErrorMatrix.make()

    to = lastindex(la_)

    for it in 1:ut

        th = th_[it]

        fill!(er, 0)

        Omics.ErrorMatrix.fil!(er, la_, pr_, th)

        tn, fn, fp, tp, np, pp, ac = Omics.ErrorMatrix.summarize(er, to)

        Omics.ErrorMatrix.plot(
            "",
            er,
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

    ra = -0.016, 1.016

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
                "marker" => Dict("size" => wi * 2.8, "color" => co),
                "line" => Dict("width" => wi, "color" => co),
                "fill" => "tozeroy",
                "fillcolor" => Omics.Color.hexify(co, 0.56),
            ),
        ),
        Dict(
            "title" => Dict("text" => "Receiver Operating Characteristic"),
            "yaxis" => Dict("range" => ra, "title" => Dict("text" => "True-Positive Rate")),
            "xaxis" =>
                Dict("range" => ra, "title" => Dict("text" => "False-Positive Rate")),
            "legend" =>
                Dict("y" => 0.08, "x" => 0.96, "yanchor" => "bottom", "xanchor" => "right"),
        ),
    )

end

end
