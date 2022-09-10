function plot(
    wm_,
    hm_;
    nar_ = ["Rows $id" for id in 1:length(wm_)],
    nac_ = ["Columns $id" for id in 1:length(wm_)],
    naf = "Factor",
    _ro_ = [["$na $id" for id in 1:size(wm, 1)] for (wm, na) in zip(wm_, nar_)],
    _co_ = [["$na $id" for id in 1:size(hm, 2)] for (hm, na) in zip(hm_, nac_)],
    ou = "",
)

    fa_ = ["$naf $id" for id in 1:size(wm_[1], 2)]

    sh = 584

    lo = sh * MathConstants.golden

    axis = Dict("dtick" => 1)

    for (id, (wm, ro_, nar)) in enumerate(zip(wm_, _ro_, nar_))

        title_text = "W $id"

        if isempty(ou)

            ou2 = ou

        else

            ou2 = joinpath(ou, "$title_text.html")

            OnePiece.table.write(
                joinpath(ou, "$title_text.tsv"),
                OnePiece.data_frame.make(ro_, fa_, wm, nar = nar),
            )

        end

        or_ = OnePiece.clustering.cluster(wm)[1]

        display(
            OnePiece.figure.plot_heat_map(
                replace(OnePiece.normalization.normalize!(wm[or_, :], 1, "-0-"), NaN => nothing),
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
                ou = ou2,
            ),
        )

    end

    for (id, (hm, co_, nac)) in enumerate(zip(hm_, _co_, nac_))

        title_text = "H $id"

        if isempty(ou)

            ou2 = ou

        else

            ou2 = joinpath(ou, "$title_text.html")

            OnePiece.table.write(
                joinpath(ou, "$title_text.tsv"),
                OnePiece.data_frame.make(fa_, co_, hm, nar = naf),
            )

        end

        or_ = OnePiece.clustering.cluster(transpose(hm))[1]

        display(
            OnePiece.figure.plot_heat_map(
                OnePiece.normalization.normalize!(hm[:, or_], 2, "-0-"),
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
                ou = ou2,
            ),
        )

    end

end
