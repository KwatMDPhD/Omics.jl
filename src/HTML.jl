module HTML

using ..BioLab

function write(id, so_, sc; he = 800, wi = 1280, ht = "")

    jo = join(
        vcat(
            "<!DOCTYPE html>",
            "<html>",
            "<head>",
            "<meta charset=\"UTF-8\">",
            "</head>",
            "<div id=\"$id\" style=\"margin: auto; min-height: $(he)px; min-width: $(wi)px; display: flex; justify-content: center; align-items: center; padding: 24px; background: #27221f;\">",
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
