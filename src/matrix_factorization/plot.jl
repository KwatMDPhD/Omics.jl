function plot(wm_, hm_, _ro_, _co_)

    fa_ = ["Factor $id" for id in 1:size(wm_[1], 2)]

    sh = 480

    lo = sh * MathConstants.golden

    axis = Dict("dtick" => 1)

    for (id, (wm, ro_)) in enumerate(zip(wm_, _ro_))

        or_ = OnePiece.clustering.cluster(wm)[1]

        display(
            OnePiece.figure.plot_heat_map(
                OnePiece.normalization.normalize!(wm[or_, :], 1, "-0-"),
                y = ro_[or_],
                x = fa_,
                layout = Dict(
                    "height" => lo,
                    "width" => sh,
                    "title" => Dict("text" => "W $id"),
                    "xaxis" => axis,
                ),
            ),
        )

    end

    for (id, (hm, co_)) in enumerate(zip(hm_, _co_))

        or_ = OnePiece.clustering.cluster(transpose(hm))[1]

        display(
            OnePiece.figure.plot_heat_map(
                OnePiece.normalization.normalize!(hm[:, or_], 2, "-0-"),
                y = fa_,
                x = co_[or_],
                layout = Dict(
                    "height" => sh,
                    "width" => lo,
                    "title" => Dict("text" => "H $id"),
                    "yaxis" => axis,
                ),
            ),
        )

    end

end
