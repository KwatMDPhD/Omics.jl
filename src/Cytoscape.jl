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
    sc = 1,
)

    if isempty(ht)

        ht = joinpath(tempdir(), "$(randstring()).html")

    end

    re = ""

    if !isempty(ex)

        fi = "$(basename(ht)[1:(end - 5)]).$ex"

        fd = joinpath(homedir(), "Downloads", fi)

        if isfile(fd)

            rm(fd)

        end

        bl = if ex == "json"

            "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            "cy.png({full: true, scale: $sc, bg: \"$ba\"})"

        end

        re = "cy.ready(function() {saveAs($bl, \"$fi\")});"

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

    if isempty(ex)

        return

    end

    _wait(fd, 32)

    fh = joinpath(dirname(ht), fi)

    if fd != fh

        mv(fd, fh; force = true)

    end

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
