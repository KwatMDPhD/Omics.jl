function plot_heat_map(ma, ro_, co_; la = Config())

    id_ = size(ma, 1):-1:1

    tr_ = [
        Config(
            type = "heatmap",
            z = collect(eachrow(ma))[id_],
            y = ro_[id_],
            x = co_,
            colorscale = "Picnic",
        ),
    ]

    plot(tr_, la)

end

function plot_heat_map(ma; ke_ar...)

    n_ro, n_co = size(ma)

    plot_heat_map(ma, string.("Row ", 1:n_ro), string.("Column ", 1:n_co); ke_ar...)

end
