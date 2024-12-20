module HTM

function writ(ht, sr_, sc; id = "wr", ba = "#ffffff")

    write(
        ht,
        """
        <!doctype html>
        <html>
          <head>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <meta charset="utf-8" />
          </head>
          $(join(("<script src=\"$sr\"></script>" for sr in sr_), '\n'))
          <body style="display: flex; justify-content: center; background: $ba">
            <div id=\"$id\"></div>
          </body>
          <script>
            $sc
          </script>
        </html>""",
    )

    ht

end

end
