function plot(el_, st_, la; ht = "", js = true, pn = true, bg = "#fdfdfd")

    di = "OnePiece.Network.plot.$(OnePiece.Time.stamp())"

    pr = splitext(basename(ht))[1]

    scj = ""

    if js

        scj = """
            let js = new Blob([JSON.stringify(cy.json(), null, 2)], {type: "application/json"});

            saveAs(js, "$pr.json");
            """

    end

    scp = ""

    if pn

        scp = """
            let pn = cy.png({"full": true, "scale": 1, "bg": "$bg"});

            saveAs(pn, "$pr.png");
            """

    end

    OnePiece.HTML.make(
        di,
        [
            "http://ajax.googleapis.com/ajax/libs/jquery/2.0.0/jquery.min.js",
            "https://cdn.rawgit.com/eligrey/FileSaver.js/master/dist/FileSaver.js",
            "https://cdnjs.cloudflare.com/ajax/libs/cytoscape/3.21.1/cytoscape.min.js",
        ],
        """
        var cy = cytoscape({

            container: document.getElementById("$di"),

            elements: $(write(el_)),

            style: $(write(st_)),

            layout: $(write(la)),

        });

        cy.ready(function() {

            $scj

            $scp

        });
        """,
        ht,
    )

end
