module Cytoscape

using JSON: json

using ..Omics

function plot(
    ht,
    el_,
    ex = "";
    st_ = Dict{String, Any}[],
    la = Dict{String, Any}(),
    co = "#ffffff",
    sc = 1,
)

    j1 = ""

    if !isempty(ex)

        @assert !isempty(ht)

        ba = "$(splitext(basename(ht))[1]).$ex"

        fi = joinpath(homedir(), "Downloads", ba)

        j2 = if ex == "json"

            "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            "cy.png({full: true, scale: $sc, bg: \"$co\"})"

        end

        j1 = "cy.ready(function() {saveAs($j2, \"$ba\")})"

    end

    id = "cy"

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
        })

        cy.on("mouseover", "node", function(ev) {
            ev.target.addClass("nodehover")
        })

        cy.on("mouseout", "node", function(ev) {
            ev.target.removeClass("nodehover")
        })

        cy.on("mouseover", "edge", function(ev) {
            ev.target.addClass("edgehover")
        })

        cy.on("mouseout", "edge", function(ev) {
            ev.target.removeClass("edgehover")
        })

        $j1""",
        co,
    )

    if isempty(ex)

        return

    end

    Omics.Path.wai(fi, 32)

    mv(fi, joinpath(dirname(ht), ba); force = true)

end

function rea(js)

    di = Omics.Dic.rea(js)["elements"]

    vcat(di["nodes"], di["edges"])

end

function _identify(el)

    el["data"]["id"]

end

function position!(e1_, e2_)

    di = Dict(_identify(el) => el for el in e2_)

    for el in e1_

        el["position"] = di[_identify(el)]["position"]

    end

end

end
