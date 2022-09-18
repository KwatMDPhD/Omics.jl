function _make_element(ve, cl_)

    Dict("data" => Dict("id" => string(ve)), "classes" => [string(cl) for cl in cl_])

end

function _make_element(ve::DataType)

    _make_element(ve, vcat("no", collect(supertypes(ve))[2:(end - 1)]))

end

function _make_element(ve::String)

    _make_element(ve, ["ed", splitext(ve)[2][2:end]])

end

function _make_element(ed::Vector)

    so, de = ed

    Dict("data" => Dict("source" => string(so), "target" => string(de)))

end

function plot(;
    js = "",
    no_si = 32,
    ed_si = no_si / 2,
    ed_wi = no_si / 8,
    edge_line_color = "#171412",
    st_ = [],
    he_ = [],
    he = 800,
    ou = "",
)

    ve_ = [_make_element(ve) for ve in VERTEX_]

    if isempty(js)

        po = false

    else

        OnePiece.network.position!(ve_, js)

        po = true

    end

    ed_ = [_make_element(ed) for ed in EDGE_]

    st_ = append!(
        [
            Dict(
                "selector" => "node",
                "style" => Dict("border-width" => 2, "border-color" => "#ebf6f7"),
            ),
            Dict(
                "selector" => ".no",
                "style" => Dict(
                    "height" => no_si,
                    "width" => no_si,
                    "label" => "data(id)",
                    "font-size" => no_si * 2 / 3,
                ),
            ),
            Dict(
                "selector" => ".ed",
                "style" => Dict("height" => ed_si, "width" => ed_si, "shape" => "triangle"),
            ),
            Dict("selector" => ".in", "style" => Dict("background-color" => "#f47983")),
            Dict("selector" => ".de", "style" => Dict("background-color" => "#4d8fac")),
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
        ],
        st_,
    )

    if !isempty(he_)

        append!(
            st_,
            [
                Dict(
                    "selector" => "#$ve",
                    "style" => Dict("background-color" => "#$(hex(get(ColorSchemes.plasma, fr)))"),
                ) for (ve, fr) in zip(
                    string.(VERTEX_),
                    replace(OnePiece.normalization.normalize(he_, "0-1"), NaN => 0),
                )
            ],
        )

    end

    la = Dict{String, Any}("name" => "grid", "animate" => false)

    if po

        merge!(la, Dict("name" => "preset"))

    elseif 1 < length(ed_)

        merge!(
            la,
            Dict(
                "name" => "cose",
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

    OnePiece.network.plot(vcat(ve_, ed_), st_, la, ou = ou, js = !po)

end
