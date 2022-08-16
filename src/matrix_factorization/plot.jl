function plot(wm_, hm_, _ro_, _co_)

    fa_ = ["Factor $id" for id in 1:size(wm_[1], 2)]

    sh = 480

    lo = sh * MathConstants.golden

    axis = Dict("dtick" => 1)

    for (id, (wm, ro_)) in enumerate(zip(wm_, _ro_))

        display(
            OnePiece.figure.plot_heat_map(
                wm,
                ro_,
                fa_,
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

        display(
            OnePiece.figure.plot_heat_map(
                hm,
                fa_,
                co_,
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
