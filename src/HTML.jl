module HTML

using DefaultApplication: open as _open

using ..BioLab

function write(di, so_, sc; he = 800, ht = "")

    st = "display: flex; justify-content: center; align-items: center;"

    jo = join(
        vcat(
            "<!DOCTYPE html>",
            "<html>",
            "<head>",
            "<meta charset=\"UTF-8\">",
            "</head>",
            "<div style=\"$st height: $(he)px; width: 99%; background: #203838; margin: auto;\">",
            "<div id=\"$di\" style=\"$st height: 99%; width: 99%; background: #f8f8f8;\"></div>",
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

    println("🖼️ $ht.")

    try

        _open(ht)

    catch

        @warn "👺 Could not open $ht."

    end

    return nothing

end

end
