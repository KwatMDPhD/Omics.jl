module HTML

using ..Nucleus

function make(ht, sr_, id, sc; ba = "#000000")

    ht =
        isempty(ht) ? joinpath(Nucleus.TE, "$(Nucleus.Time.stamp()).html") : Nucleus.Path.clean(ht)

    write(
        ht,
        join(
            (
                "<!DOCTYPE html>",
                "<html>",
                "<head>",
                "<meta charset=\"utf-8\">",
                "</head>",
                ("<script src=\"$sr\"></script>" for sr in sr_)...,
                "<div id=\"$id\" style=\"margin: auto; min-height: 800px; min-width: 1280px; display: flex; justify-content: center; align-items: center; padding: 24px; background: $ba;\"></div>",
                "<script>",
                sc,
                "</script>",
                "</html>",
            ),
            '\n',
        ),
    )

    Nucleus.Path.open(ht)

end

end
