module HTM

function writ(ht, sr_, id, sc, ba = "#000000")

    write(
        ht,
        """
        <!doctype html>
        <html>
          <head>
            <meta charset="utf-8" />
          </head>
        $(join(("<script src=\"$sr\"></script>" for sr in sr_), '\n'))
          <body style="height: 100vh; background: $ba; margin: 0">
            <div id="$id" style="height: 100%; min-height: fit-content; min-width: fit-content; display: flex; justify-content: center; align-items: center"></div>
          </body>
          <script>
        $sc
          </script>
        </html>""",
    )

    ht

end

end
