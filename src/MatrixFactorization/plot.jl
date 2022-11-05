function plot(
    ro_x_fa_x_po_,
    fa_x_co_x_po_;
    nar_ = ["Rows $id" for id in 1:length(ro_x_fa_x_po_)],
    nac_ = ["Columns $id" for id in 1:length(fa_x_co_x_po_)],
    naf = "Factor",
    ro__ = (
        ["$na $id" for id in 1:size(ro_x_fa_x_po, 1)] for
        (ro_x_fa_x_po, na) in zip(ro_x_fa_x_po_, nar_)
    ),
    co__ = (
        ["$na $id" for id in 1:size(fa_x_co_x_po, 2)] for
        (fa_x_co_x_po, na) in zip(fa_x_co_x_po_, nac_)
    ),
    di = "",
)

    #
    fa_ = ["$naf $id" for id in 1:size(ro_x_fa_x_po_[1], 2)]

    #
    lo = 1000

    sh = lo / MathConstants.golden

    axis = Dict("dtick" => 1.0)

    #
    for (id, (ro_x_fa_x_po, ro_, nar)) in enumerate(zip(ro_x_fa_x_po_, ro__, nar_))

        #
        title_text = "W.$id"

        #
        if isemptry(di)

            ht = ""

        else

            ht = joinpath(di, "$title_text.html")

            OnePiece.Table.write(
                joinpath(di, "$title_text.tsv"),
                OnePiece.DataFrame.make(nar, ro_, fa_, ro_x_fa_x_po),
            )

        end

        #
        or_ = OnePiece.Clustering.hierarchize(ro_x_fa_x_po).order

        OnePiece.Plot.plot_heat_map(
            OnePiece.Normalization.normalize(ro_x_fa_x_po[or_, :], 1, "-0-"),
            ro_[or_],
            fa_,
            nar = nar,
            nac = naf,
            layout = Dict(
                "height" => lo,
                "width" => sh,
                "title" => Dict("text" => title_text),
                "xaxis" => axis,
            ),
            ht = ht,
        )

    end

    #
    for (id, (fa_x_co_x_po, co_, nac)) in enumerate(zip(fa_x_co_x_po_, co__, nac_))

        #
        title_text = "H.$id"

        #
        if isemptry(di)

            ht = ""

        else

            ht = joinpath(di, "$title_text.html")

            OnePiece.Table.write(
                joinpath(di, "$title_text.tsv"),
                OnePiece.DataFrame.make(naf, fa_, co_, fa_x_co_x_po),
            )

        end

        #
        or_ = OnePiece.Clustering.hierarchize(transpose(fa_x_co_x_po)).order

        OnePiece.Plot.plot_heat_map(
            OnePiece.Normalization.normalize(fa_x_co_x_po[:, or_], 2, "-0-"),
            fa_,
            co_[or_],
            nar = naf,
            nac = nac,
            layout = Dict(
                "height" => sh,
                "width" => lo,
                "title" => Dict("text" => title_text),
                "yaxis" => axis,
            ),
            ht = ht,
        )

    end

end
