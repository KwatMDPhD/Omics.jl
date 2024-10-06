module HTML

using Random: randstring

function write(ht, sr_, sc; id = randstring(), ba = "#000000")

    Base.write(
        ht,
        """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="utf-8">
        </head>
        $(join(("<script src=\"$sr\"></script>" for sr in sr_), '\n'))
        <div id=\"$id\" style="min-height: fit-content; min-width: fit-content; display: flex; justify-content: center; align-items: center; padding: 8px; background: $ba;"></div>
        <script>
            $sc
        </script>
        </html>""",
    )

    ht

end

end