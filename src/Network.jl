module Network

using JSON3: write

using ..BioLab

function plot(
    ht,
    el_;
    st_ = (),
    la = Dict{String, Any}(),
    ex = "",
    pns = 1,
    ba = "#fcfcfc",
    ke_ar...,
)

    if isempty(ex)

        fi = ""

        re = ""

    else

        if isempty(ht)

            error("HTML path, which is needed for saving a $ex, is empty.")

        end

        pr = splitext(basename(ht))[1]

        na = "$pr.$ex"

        fi = joinpath(homedir(), "Downloads", na)

        BioLab.Path.warn_overwrite(fi)

        rm(fi; force = true)

        if ex == "json"

            bl = "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            # TODO: Try unquoting the hex color.
            bl = "cy.png({\"full\": true, \"scale\": $pns, \"bg\": \"$ba\"})"

        else

            error("Can not write a $ex.")

        end

        re = "cy.ready(function() {saveAs($bl, \"$na\");});"

    end

    id = "Cytoscape"

    elj = write(el_)

    stj = write(st_)

    laj = write(merge!(Dict("animate" => false), la))

    BioLab.HTML.make(
        ht,
        id,
        # TODO: Use the latest.
        (
            "http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js",
            "https://cdn.rawgit.com/eligrey/FileSaver.js/master/dist/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.25.0/cytoscape.min.js",
        ),
        """var cy = cytoscape({
            container: document.getElementById("$id"),
            elements: $elj,
            style: $stj,
            layout: $laj,
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

    if !isempty(fi)

        BioLab.Path.wait(fi)

        if ex == "png"

            BioLab.Path.open(fi)

        end

    end

end

function position!(el_, el2_)

    id_el2 = Dict(el["data"]["id"] => el for el in el2_)

    for el in el_

        el["position"] = id_el2[el["data"]["id"]]["position"]

    end

end

end
