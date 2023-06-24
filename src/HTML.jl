module HTML

using ..BioLab

function make(ht, id, so_, sc; he = 800, wi = 1280, ba = "#27221f")

    if isempty(ht)

        st = BioLab.Time.stamp()

        ht = joinpath(BioLab.TE, "$st.html")

    else

        BioLab.Path.warn_overwrite(ht)

        BioLab.Path.error_extension_difference(ht, "html")

    end

    write(
        ht,
        join(
            vcat(
                "<!DOCTYPE html>",
                "<html>",
                "<head>",
                "<meta charset=\"UTF-8\">",
                "</head>",
                "<div id=\"$id\" style=\"margin: auto; min-height: $(he)px; min-width: $(wi)px; display: flex; justify-content: center; align-items: center; padding: 24px; background: $ba;\"></div>",
                ["<script src=\"$so\"></script>" for so in so_],
                "<script>$sc</script>",
                "</html>",
            ),
            '\n',
        ),
    )

    BioLab.Path.open(ht)

end

end
