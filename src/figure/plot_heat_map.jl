function plot_heat_map(
    ma,
    ro_ = string.("Row ", 1:size(ma, 1)),
    co_ = string.("Column ", 1:size(ma, 2));
    la = Dict(),
    ou = "",
)

    id_ = size(ma, 1):-1:1

    tr_ = [
        Dict(
            "type" => "heatmap",
            "z" => collect(eachrow(ma))[id_],
            "y" => ro_[id_],
            "x" => co_,
            "colorscale" => "Picnic",
        ),
    ]

    plot(tr_, la, ou = ou)

end
