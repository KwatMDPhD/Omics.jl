module HTML

using ..Nucleus

function make(ht, sr_, id, sc; ba = Nucleus.Color.HEDA)

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
                "<div id=\"$id\" style=\"min-height: fit-content; min-width: fit-content; display: flex; justify-content: center; align-items: center; padding: 8px; background: $ba;\"></div>",
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
