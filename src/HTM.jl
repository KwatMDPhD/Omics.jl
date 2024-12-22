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
          <body style="background: $ba; margin: 0">
            <div id="$id" style="min-height: 100vh; min-width: fit-content; display: flex; justify-content: center; align-items: center"></div>
          </body>
          <script>
        $sc
          </script>
        </html>""",
    )

    ht

end

end
