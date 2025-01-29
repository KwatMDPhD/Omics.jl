module Plot

using JSON: json

using ..Nucleus

function plot(
    ht,
    el_;
    st_ = Dict{String, Any}(),
    la = Dict{String, Any}(),
    ba = "#fcfcfc",
    ex = "",
    sc = 1,
    ke_ar...,
)

    if isempty(ex)

        dw = ""

        re = ""

    else

        if isempty(ht)

            error("HTML path is empty.")

        end

        na = "$(splitext(basename(ht))[1]).$ex"

        dw = joinpath(homedir(), "Downloads", na)

        if isfile(dw)

            rm(dw)

        end

        if ex == "json"

            bl = "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            bl = "cy.png({full: true, scale: $sc, bg: \"$ba\"})"

        else

            error("`$ex` is not `json` or `png`.")

        end

        re = "cy.ready(function() {saveAs($bl, \"$na\")});"

    end

    id = "Cytoscape"

    Nucleus.HTML.make(
        ht,
        (
            "https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js",
            "https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.29.2/cytoscape.min.js",
        ),
        id,
        """
        var cy = cytoscape({
            container: document.getElementById("$id"),
            elements: $(json(el_)),
            style: $(json(st_)),
            layout: $(json(merge(Dict("animate" => false), la))),
        });

        cy.on("mouseover", "node", function(ev) {
            ev.target.addClass("nodehover");
        });

        cy.on("mouseout", "node", function(ev) {
            ev.target.removeClass("nodehover");
        });

        cy.on("mouseover", "edge", function(ev) {
            ev.target.addClass("edgehover");
        });

        cy.on("mouseout", "edge", function(ev) {
            ev.target.removeClass("edgehover");
        });

        $re""";
        ba,
        ke_ar...,
    )

    if !isempty(dw)

        Nucleus.Path.wait(dw, 40)

        fi = joinpath(dirname(ht), na)

        if dw != fi

            if isfile(fi)

                rm(fi)

            end

            mv(dw, fi)

        end

    end

    return nothing

end

function read(js)

    ty_el_ = Nucleus.Dict.read(js, Dict{String, Any})["elements"]

    el_ = ty_el_["nodes"]

    ke = "edges"

    if haskey(ty_el_, ke)

        append!(el_, ty_el_[ke])

    end

    return el_

end

function position!(el_, el2_)

    id_el2 = Dict(el["data"]["id"] => el for el in el2_)

    for el in el_

        el["position"] = id_el2[el["data"]["id"]]["position"]

    end

end

function plot(
    ht;
    el_ = Dict{String, Any}[],
    he_ = Float64[],
    st_ = Dict{String, Any}[],
    nos = 24,
    coe = Nucleus.Color.HEGE,
    col1 = "#ffffff",
    col2 = Nucleus.Color.HEDA,
    ex = "",
)

    if isempty(NO_)

        @warn "There is not any node to plot."

        return

    end

    no_ = _elementize.(NO_, CL___)

    if !isempty(el_)

        position!(no_, el_)

    end

    if !isempty(he_)

        if lastindex(no_) != lastindex(he_)

            error("Numbers of nodes differ.")

        end

        for (no, he) in zip(no_, he_)

            no["data"]["weight"] = he

            push!(
                st_,
                Dict(
                    "selector" => "#$(no["data"]["id"])",
                    "style" => Dict("background-color" =>
                        Nucleus.Color.color(he, Nucleus.Color.COBW)),
                ),
            )

        end

    end

    ed_ = _elementize.(ED_)

    tri_ = (0.866, 0.5, -0.866, 0.5, 0, -1)

    hos = nos * 0.64

    ga = nos * 0.16

    return Nucleus.Graph.plot(
        ht,
        vcat(no_, ed_);
        st_ = append!(
            [
                Dict(
                    "selector" => "node",
                    "style" => Dict(
                        "border-width" => 1.6,
                        "border-color" => Nucleus.Color.HEFA,
                        "font-size" => nos * 0.64,
                    ),
                ),
                Dict(
                    "selector" => ".no",
                    "style" => Dict("height" => nos, "width" => nos, "label" => "data(id)"),
                ),
                Dict(
                    "selector" => ".ho",
                    "style" => Dict("shape" => "polygon", "height" => hos, "width" => hos),
                ),
                Dict(
                    "selector" => ".de",
                    "style" => Dict(
                        "shape-polygon-points" => .-tri_,
                        "background-color" => Nucleus.Color.HEAY,
                    ),
                ),
                Dict(
                    "selector" => ".in",
                    "style" => Dict(
                        "shape-polygon-points" => tri_,
                        "background-color" => Nucleus.Color.HEAG,
                    ),
                ),
                Dict(
                    "selector" => ".nodehover",
                    "style" => Dict(
                        "border-style" => "double",
                        "border-color" => coe,
                        "label" => "data(weight)",
                    ),
                ),
                Dict(
                    "selector" => "edge",
                    "style" => Dict(
                        "source-distance-from-node" => ga,
                        "target-distance-from-node" => ga,
                        "curve-style" => "bezier",
                        "width" => nos * 0.08,
                        "line-opacity" => 0.64,
                        "line-fill" => "linear-gradient",
                        "line-gradient-stop-colors" => (col1, col2),
                        "target-arrow-shape" => "triangle-backcurve",
                        "arrow-scale" => 1.6,
                        "target-arrow-color" => col2,
                    ),
                ),
                Dict(
                    "selector" => ".edgehover",
                    "style" => Dict(
                        "line-opacity" => 1,
                        "line-gradient-stop-colors" => (col1, coe),
                        "target-arrow-color" => coe,
                    ),
                ),
            ],
            st_,
        ),
        la = if isempty(el_)
            Dict(
                "name" => "cose",
                "padding" => 16,
                #"boundingBox" => Dict("y1" => 0, "x1" => 0, "h" => hi, "w" => wi),
                "componentSpacing" => 40,
                "nodeRepulsion" => 8000,
                "idealEdgeLength" => 16,
                "numIter" => 10000,
            )
        else
            Dict("name" => "preset")
        end,
        ex,
    )

end

end
