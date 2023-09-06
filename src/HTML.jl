module HTML

using ..BioLab

function make(ht, id, sr_, sc; he = 800, wi = 1280, ba = "#27221f")

    if isempty(ht)

        ht = joinpath(BioLab.TE, "$(BioLab.Time.stamp()).html")

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
                "<div id=\"$id\" style=\"margin: auto; min-height: $(he)px; min-width: $(wi)px; display: flex; justify-content: center; align-items: center; padding: 24px; background: $ba;\"></div>",
                ("<script src=\"$sr\"></script>" for sr in sr_)...,
                "<script>",
                sc,
                "</script>",
                "</html>",
            ),
            '\n',
        ),
    )

    BioLab.Path.open(ht)

    ht

end

end
