module HTM

using Random: randstring

using ..Omics

function writ(ht, sr_, id, js, co = "#000000")

    if isempty(ht)

        ht = joinpath(tempdir(), "$(randstring()).html")

    end

    write(
        ht,
        """
        <!doctype html>
        <html>
          <head>
            <meta charset="utf-8" />
          </head>
        $(join(("<script src=\"$sr\"></script>" for sr in sr_), '\n'))
          <body style="margin: 0; background: $co">
            <div id="$id" style="min-height: 100vh; min-width: fit-content; display: flex; justify-content: center; align-items: center"></div>
          </body>
          <script>
        $js
          </script>
        </html>""",
    )

    Omics.Path.ope(ht)

end

end
