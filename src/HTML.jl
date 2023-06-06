module HTML

using ..BioLab

function write(di, so_, sc; he = 800, wi = 1280, ht = "")

    jo = join(
        vcat(
            "<!DOCTYPE html>",
            "<html>",
            "<head>",
            "<meta charset=\"UTF-8\">",
            "</head>",
            "<div style=\"margin: auto; height: $(he)px; width: $(wi)px; display: flex; justify-content: center; align-items: center; background: #203838;\">",
            "<div id=\"$di\" style=\"height: $(he-2)px; width: $(wi-2)px; background: #f8f8f8;\"></div>",
            "</div>",
            ["<script src=\"$so\"></script>" for so in so_],
            "<script>",
            sc,
            "</script>",
            "</html>",
        ),
        '\n',
    )

    if isempty(ht)

        ht = joinpath(BioLab.TE, "$(BioLab.Time.stamp()).html")

    end

    Base.write(ht, jo)

    try

        run(`open --background $ht`)

    catch

        @warn "Could not open $ht."

    end

end

end
