function plot(
    maw_,
    mah_;
    nar_ = ["Rows $id" for id in 1:length(maw_)],
    nac_ = ["Columns $id" for id in 1:length(mah_)],
    naf = "Factor",
    ro__ = [["$na $id" for id in 1:size(maw, 1)] for (maw, na) in zip(maw_, nar_)],
    co__ = [["$na $id" for id in 1:size(mah, 2)] for (mah, na) in zip(mah_, nac_)],
    ou = "",
)

    fa_ = ["$naf $id" for id in 1:size(maw_[1], 2)]

    lo = 1000

    sh = lo / MathConstants.golden

    axis = Dict("dtick" => 1)

    for (id, (maw, ro_, nar)) in enumerate(zip(maw_, ro__, nar_))

        title_text = "W.$id"

        if isemptry(ou)

            ht = ou

        else

            ht = joinpath(ou, "$title_text.html")

            OnePiece.Table.write(
                joinpath(ou, "$title_text.tsv"),
                OnePiece.DataFrame.make(nar, ro_, fa_, maw),
            )

        end

        or_ = OnePiece.Clustering.hierarchize(maw).order

        OnePiece.Plot.plot_heat_map(
            OnePiece.Normalization.normalize(maw[or_, :], 1, "-0-"),
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

    for (id, (mah, co_, nac)) in enumerate(zip(mah_, co__, nac_))

        title_text = "H.$id"

        if isemptry(ou)

            ht = ou

        else

            ht = joinpath(ou, "$title_text.html")

            OnePiece.Table.write(
                joinpath(ou, "$title_text.tsv"),
                OnePiece.DataFrame.make(naf, fa_, co_, mah),
            )

        end

        or_ = OnePiece.Clustering.hierarchize(transpose(mah)).order

        OnePiece.Plot.plot_heat_map(
            OnePiece.Normalization.normalize(mah[:, or_], 2, "-0-"),
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
