module Graph

using JSON: json

using ..BioLab

function plot(
    ht,
    el_;
    st = Dict{String, Any}(),
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

            BioLab.Path.remove(dw)

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

    BioLab.HTML.make(
        ht,
        # TODO: Use the latest.
        (
            "http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js",
            "https://cdn.rawgit.com/eligrey/FileSaver.js/master/dist/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.25.0/cytoscape.min.js",
        ),
        id,
        """
        var cy = cytoscape({
            container: document.getElementById("$id"),
            elements: $(json(el_)),
            style: $(json(st)),
            layout: $(json(merge!(Dict("animate" => false), la))),
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

        BioLab.Path.wait(dw, 40)

        fi = joinpath(dirname(ht), na)

        if isfile(fi)

            BioLab.Path.remove(fi)

        end

        mv(dw, fi)

    end

    nothing

end

function read(js)

    ty_el_ = BioLab.Dict.read(js)["elements"]

    el_ = ty_el_["nodes"]

    ke = "edges"

    if haskey(ty_el_, ke)

        append!(el_, ty_el_[ke])

    end

    el_

end

function position!(el_, el2_)

    id_el2 = Dict(el["data"]["id"] => el for el in el2_)

    for el in el_

        el["position"] = id_el2[el["data"]["id"]]["position"]

    end

end

end
