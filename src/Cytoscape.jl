module Cytoscape

using JSON: json

using Random: randstring

using ..Omics

# TODO: Generalize.
function _wait(pa, ma = 4; sl = 1)

    us = 0

    while us < ma && !ispath(pa)

        sleep(sl)

        @info "Waiting for $pa ($(us += sl) / $ma)"

    end

end

function plot(
    ht,
    el_;
    st_ = Dict{String, Any}(),
    la = Dict{String, Any}(),
    ba = "#ffffff",
    ex = "",
    sc = 1.0,
)

    if isempty(ht)

        ht = joinpath(tempdir(), "$(randstring()).html")

    end

    if isempty(ex)

        dw = re = ""

    else

        ba = "$(basename(ht)[1:(end - 5)]).$ex"

        dw = joinpath(homedir(), "Downloads", ba)

        if isfile(dw)

            rm(dw)

        end

        bl = if ex == "json"

            "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            "cy.png({full: true, scale: $sc, bg: \"$ba\"})"

        end

        re = "cy.ready(function() {saveAs($bl, \"$ba\")});"

    end

    id = "cy"

    Omics.Path.ope(
        Omics.HTM.writ(
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

            $re""",
            ba,
        ),
    )

    if isempty(dw)

        return

    end

    _wait(dw, 40)

    mv(dw, joinpath(dirname(ht), ba); force = true)

end

function rea(js)

    ty_el_ = Omics.Dic.rea(js)["elements"]

    vcat(ty_el_["nodes"], get(ty_el_, "edges", []))

end

function position!(e1_, e2_)

    id_e2 = Dict(e2["data"]["id"] => e2 for e2 in e2_)

    for e1 in e1_

        e1["position"] = id_e2[e1["data"]["id"]]["position"]

    end

end

end
