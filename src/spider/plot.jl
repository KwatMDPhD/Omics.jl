function _make_element(ve, cl_)

    Dict("data" => Dict("id" => ve), "classes" => cl_)

end

function _make_element(ve::DataType)

    _make_element(ve, ["no"])

end

function _make_element(ve::String)

    _make_element(ve, ["ed", splitext(ve)[2]])

end

function _make_element((so, ta)::Tuple)

    Dict("data" => Dict("source" => so, "target" => ta))

end

function plot(;
    no_si = 32,
    ed_si = no_si / 2,
    ed_wi = no_si / 8,
    edge_line_color = "#171412",
    st_ = [],
    he = 800,
    ou = "",
)

    ve_ = _make_element.(VE_)

    ed_ = _make_element.(ED_)

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
            "style" => Dict("height" => ed_si, "width" => ed_si, "shape" => "triangle"),
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

    la = Dict()

    if !isempty(ed_)

        la = OnePiece.dict.merge(
            la,
            Dict(
                "name" => "cose",
                "animate" => false,
                "padding" => 16,
                "boundingBox" =>
                    Dict("x1" => 0, "y1" => 0, "h" => he, "w" => he * MathConstants.golden),
                "componentSpacing" => 40,
                "nodeRepulsion" => 8000,
                "idealEdgeLength" => 16,
                "numIter" => 10000,
            ),
        )

    end

    OnePiece.network.plot([ve_; ed_], st_, la, ou = ou)

end
