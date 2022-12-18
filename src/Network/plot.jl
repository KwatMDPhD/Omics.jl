function plot(el_, st_, la; bg = "#fdfdfd", ht = "", wr = "")

    di = "BioLab.Network.plot.$(BioLab.Time.stamp())"

    if isempty(ht)

        pr = @__MODULE__

    else

        pr = splitext(basename(ht))[1]

    end

    if wr == "json"

        re = """
        let blj = new Blob([JSON.stringify(cy.json(), null, 2)], {type: "application/json"});
        let paj = "$pr.json";
        saveAs(blj, paj);
        """

    elseif wr == "png"

        re = """
        let blp = cy.png({"full": true, "scale": 1.0, "bg": "$bg"});
        let pap = "$pr.png";
        saveAs(blp, pap);
        """

    else

        re = ""

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

        cy.ready(function() {
            $re
        });


        cy.on("mouseover", "node", function(ev) {
            ev.target.style({
                "border-style": "double",
                "border-color": "#20d9ba",
            });
        });

        cy.on("mouseout", "node", function(ev) {
            ev.target.style({
                "border-style": "",
                "border-color": "#ebf6f7",
            });
        });

        cy.on("mouseover", "edge", function(ev) {
            ev.target.style({
                "label": ev.target.data("id"),
                "target-arrow-shape": "triangle-backcurve",
                "line-color": "#20d9ba",
                "line-opacity": 1,
            });
        });

        cy.on("mouseout", "edge", function(ev) {
            ev.target.style({
                "label": "",
                "target-arrow-shape": "",
                "line-color": "#171412",
                "line-opacity": 0.64,
            });
        });
        """,
        ht,
    )

end
