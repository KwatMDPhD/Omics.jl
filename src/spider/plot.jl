function plot(; no_si = 32, st_ = [], ou = "")

    ve_ = make_element.(VE_)

    ed_ = make_element.(ED_)

    edge_line_color = "#171412"

    noe_si = no_si / 2

    ed_wi = no_si / 8

    st_ = [
        Dict(
            "selector" => "node",
            "style" => Dict(
                "border-width" => 1,
                "border-color" => "#ebf6f7",
                "font-size" => no_si * 2 / 3,
            ),
        ),
        Dict(
            "selector" => ".no",
            "style" => Dict("height" => no_si, "width" => no_si, "label" => "data(id)"),
        ),
        Dict(
            "selector" => ".ed",
            "style" => Dict("height" => noe_si, "width" => noe_si, "shape" => "triangle"),
        ),
        Dict("selector" => ".act", "style" => Dict("background-color" => "#ffa400")),
        Dict("selector" => ".react", "style" => Dict("background-color" => "#ff1968")),
        Dict(
            "selector" => "edge",
            "style" => Dict(
                "width" => ed_wi,
                "curve-style" => "straight-triangle",
                "line-color" => edge_line_color,
                "target-arrow-shape" => "triangle-backcurve",
                "target-arrow-color" => edge_line_color,
                "source-distance-from-node" => ed_wi,
                "target-distance-from-node" => ed_wi,
                "opacity" => 0.32,
            ),
        ),
        st_...,
    ]

    he = 1000

    la = Dict(
        "name" => "cose",
        "animate" => false,
        "padding" => 16,
        "boundingBox" =>
            Dict("x1" => 0, "y1" => 0, "h" => he, "w" => he * MathConstants.golden),
        "componentSpacing" => 40,
        "nodeRepulsion" => 8000,
        "idealEdgeLength" => 16,
        "numIter" => 10000,
    )

    OnePiece.network.plot([ve_; ed_], st_, la, ou = ou)

end
