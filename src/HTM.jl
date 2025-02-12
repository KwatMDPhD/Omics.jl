module HTM

using Random: randstring

function writ(fi, sr_, id, sc, co = "#000000")

    if isempty(fi)

        fi = joinpath(tempdir(), "$(randstring()).html")

    end

    write(
        fi,
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
        $sc
          </script>
        </html>""",
    )

    fi

end

end
