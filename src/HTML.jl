module HTML

using ..BioLab

function get_height()

    800

end


function get_width()

    1280

end

function make(ht, sr_, id, sc; he = get_height(), wi = get_width(), ba = "#27221f")

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

    BioLab.Path.open(ht)

end

end
