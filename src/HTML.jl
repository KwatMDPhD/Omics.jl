module HTML

using ..Nucleus

const HE = 800

const WI = 1280

function make(ht, sr_, id, sc; he = HE, wi = WI, ba = "#27221f")

    if isempty(ht)

        ht = joinpath(Nucleus.TE, "$(Nucleus.Time.stamp()).html")

    end

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
                "<div id=\"$id\" style=\"margin: auto; min-height: $(he)px; min-width: $(wi)px; display: flex; justify-content: center; align-items: center; padding: 24px; background: $ba;\"></div>",
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
