module Cytoscape

using JSON: json

using ..Omics

function plot(
    f1,
    el_,
    ex = "";
    st_ = Dict{String, Any}[],
    la = Dict{String, Any}(),
    co = "#ffffff",
    sc = 1,
)

    re = ""

    if !isempty(ex)

        @assert !isempty(f1)

        ba = "$(splitext(basename(f1))[1]).$ex"

        f2 = joinpath(homedir(), "Downloads", ba)

        bl = if ex == "json"

            "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            "cy.png({full: true, scale: $sc, bg: \"$co\"})"

        end

        re = "cy.ready(function() {saveAs($bl, \"$ba\")});"

    end

    id = "cy"

    Omics.Path.ope(
        Omics.HTM.writ(
            f1,
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
            co,
        ),
    )

    if isempty(ex)

        return

    end

    Omics.Path.wait(f2, 32)

    mv(f2, joinpath(dirname(f1), ba); force = true)

end

function rea(fi)

    ty = Omics.Dic.rea(fi)["elements"]

    vcat(ty["nodes"], ty["edges"])

end

function _identify(el)

    el["data"]["id"]

end

function position!(e1_, e2_)

    id = Dict(_identify(el) => el for el in e2_)

    for el in e1_

        el["position"] = id[_identify(el)]["position"]

    end

end

end
