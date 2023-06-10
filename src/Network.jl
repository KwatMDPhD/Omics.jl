module Network

using JSON3: write

using ..BioLab

function position!(el_, el2_)

    id_el2 = Dict(el["data"]["id"] => el for el in el2_)

    for el in el_

        el["position"] = id_el2[el["data"]["id"]]["position"]

    end

end

function plot(
    el_;
    st_ = (),
    la = Dict{String, Any}(),
    ex = "",
    pns = 1,
    ba = "#fcfcfc",
    ht = "",
    ke_ar...,
)

    id = "BioLab.Network.plot.$(BioLab.Time.stamp())"

    if isempty(ht)

        pr = @__MODULE__

    else

        pr = splitext(basename(ht))[1]

    end

    if isempty(ex)

        fi = ""

        re = ""

    else

        na = "$pr.$ex"

        fi = joinpath(homedir(), "Downloads", na)

        rm(fi; force = true)

        if ex == "json"

            bl = "new Blob([JSON.stringify(cy.json(), null, 2)], {type: \"application/json\"})"

        elseif ex == "png"

            bl = "cy.png({\"full\": true, \"scale\": $pns, \"bg\": \"$ba\"})"
        else

            error("Can not write a $ex.")

        end

        re = "cy.ready(function() {saveAs($bl, \"$na\");});"

    end

    la = merge(Dict("animate" => false), la)

    BioLab.HTML.write(
        id,
        # TODO: Use the latest.
        (
            "http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js",
            "https://cdn.rawgit.com/eligrey/FileSaver.js/master/dist/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.25.0/cytoscape.min.js",
        ),
        """var cy = cytoscape({
            container: document.getElementById("$id"),
            elements: $(write(el_)),
            style: $(write(st_)),
            layout: $(write(la)),
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

        while !ispath(fi)

            sleep(1)

            @info "Waiting for $fi"

        end

        if ex == "png"

            run(`open --background $fi`)

        end

    end

end

end
