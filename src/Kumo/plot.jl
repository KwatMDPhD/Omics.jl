#
function _make_vertex(ve, cl_)

    Dict("data" => Dict("id" => string(ve)), "classes" => [string(cl) for cl in cl_])

end

#
function _make_vertex(ve::DataType)

    _make_vertex(ve, vcat("ve", collect(supertypes(ve))[2:(end - 1)]))

end

function _make_vertex(ve)

    _make_vertex(ve, ("ed", splitext(ve)[2][2:end]))

end

#
function _make_edge(so, de)

    Dict("data" => Dict("source" => string(so), "target" => string(de)))

end

#
function plot(;
    js = "",
    no_si = 16.0,
    ed_si = no_si / 2.0,
    ed_wi = no_si / 8.0,
    edge_line_color = "#171412",
    st_ = [],
    he_ = [],
    wi = 800,
    ht = "",
    pn = true,
)

    #
    ve_ = [_make_vertex(ve) for ve in VE_]

    #
    if isempty(js)

        js = true

    else

        BioLab.Network.position!(ve_, js)

        js = false

    end

    #
    ed_ = [_make_edge(so, de) for (so, de) in ED_]

    edv_ = Set()

    for ed in ed_

        push!(edv_, ed["data"]["source"])

        push!(edv_, ed["data"]["target"])

    end

    filter!(ve -> ve["data"]["id"] in edv_, ve_)

    #
    st_ = append!(
        [
            #
            Dict(
                "selector" => "node",
                "style" => Dict("border-width" => 2.0, "border-color" => "#ebf6f7"),
            ),
            #
            Dict(
                "selector" => ".ve",
                "style" => Dict(
                    "height" => no_si,
                    "width" => no_si,
                    "label" => "data(id)",
                    "font-size" => no_si * 2 / 3,
                ),
            ),
            #
            Dict(
                "selector" => ".ed",
                "style" => Dict("height" => ed_si, "width" => ed_si, "shape" => "triangle"),
            ),
            Dict("selector" => ".in", "style" => Dict("background-color" => "#f47983")),
            Dict("selector" => ".de", "style" => Dict("background-color" => "#4d8fac")),
            #
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

    #
    if !isempty(he_)

        append!(
            st_,
            (
                Dict(
                    "selector" => "#$st",
                    "style" => Dict("background-color" => BioLab.Plot.color("plasma", fr)),
                ) for
                (st, fr) in zip(_stringify_vertex(), BioLab.Normalization.normalize(he_, "0-1"))
            ),
        )

    end

    #
    la = Dict{String, Any}("animate" => false)

    if !js

        me = Dict("name" => "preset")

    elseif 1 < length(ed_)

        me = Dict(
            "name" => "cose",
            "padding" => 16,
            "boundingBox" =>
                Dict("x1" => 0, "y1" => 0, "h" => wi / MathConstants.golden, "w" => wi),
            "componentSpacing" => 40,
            "nodeRepulsion" => 8000,
            "idealEdgeLength" => 16,
            "numIter" => 10^4,
        )

    else

        me = Dict("name" => "grid")

    end

    merge!(la, me)

    #
    BioLab.Network.plot(vcat(ve_, ed_), st_, la, ht = ht, js = js, pn = pn)

end
