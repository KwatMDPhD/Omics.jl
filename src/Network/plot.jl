function plot(
    el_,
    st_,
    la;
    emc = "#20d9ba",
    boc = "#ebf6f7",
    lic = "#171412",
    lio = 0.56,
    ht = "",
    wr = "",
    sc = 1.0,
    bg = "#fdfdfd",
)

    di = "BioLab.Network.plot.$(BioLab.Time.stamp())"

    if isempty(ht)

        pr = @__MODULE__

    else

        pr = splitext(basename(ht))[1]

    end

    if isempty(wr)

        re = ""

    else

        if wr == "json"

            bl = """
            new Blob([JSON.stringify(cy.json(), null, 2)], {type: "application/json"})"""

        elseif wr == "png"

            bl = """
            cy.png({"full": true, "scale": $sc, "bg": "$bg"})"""

        end

        re = """
        cy.ready(function() {
            saveAs($bl, "$pr.$wr");
        });"""

    end

    BioLab.HTML.make(
        di,
        (
            "http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js",
            "https://cdn.rawgit.com/eligrey/FileSaver.js/master/dist/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.1/cytoscape.min.js",
        ),
        """
        var cy = cytoscape({
            container: document.getElementById("$di"),
            elements: $(write(el_)),
            style: $(write(st_)),
            layout: $(write(la)),
        });

        cy.on("mouseover", "node", function(ev) {
            ev.target.style({
                "label": ev.target.data("weight"),
                "border-style": "double",
                "border-color": "$emc",
            });
        });

        cy.on("mouseout", "node", function(ev) {
            ev.target.style({
                "label": ev.target.data("id"),
                "border-style": "",
                "border-color": "$boc",
            });
        });

        cy.on("mouseover", "edge", function(ev) {
            ev.target.style({
                "target-arrow-shape": "triangle-backcurve",
                "target-arrow-color": "$emc",
                "line-color": "$emc",
                "line-opacity": 1,
            });
        });

        cy.on("mouseout", "edge", function(ev) {
            ev.target.style({
                "target-arrow-shape": "",
                "line-color": "$lic",
                "line-opacity": $lio,
            });
        });

        $re""",
        ht,
    )

end
