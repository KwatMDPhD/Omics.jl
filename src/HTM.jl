module HTM

function writ(ht, sr_, id, sc, ba = "#ff0000")

    write(
        ht,
        """
        <!doctype html>
        <html>
          <head>
            <meta charset="utf-8" />
          </head>
        $(join(("<script src=\"$sr\"></script>" for sr in sr_), '\n'))
          <body style="height: 100vh; width: 100vw; background: $ba; margin: 0">
            <div id="$id" style="height: 100%; width: 100%"></div>
          </body>
          <script>
        $sc
          </script>
        </html>""",
    )

    ht

end

end
