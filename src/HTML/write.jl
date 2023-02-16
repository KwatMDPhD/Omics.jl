function write(di, so_, sc; ht = joinpath(BioLab.TE, "$(BioLab.Time.stamp()).html"), he = 800)

    st = "display: flex; justify-content: center; align-items: center;"

    li_ = vcat(
        "<!doctype html>",
        """
        <div style="$st height: $(he)px; width: 99%; background: #203838; margin: auto;">
            <div id="$di" style="$st height: 99%; width: 99%; background: #f8f8f8;"></div>
        </div>""",
        ["<script src=\"$so\"></script>" for so in so_],
        """
        <script>
        $sc
        </script>""",
    )

    jo = join(li_, '\n')

    open(ht, "w") do io

        write(io, jo)

    end

    println("🖼️ Wrote $ht.")

    if displayable("html")

        display(Base.HTML(jo))

    else

        print("💥 HTML is not displayable")

        try

            DefaultApplication_open(ht)

            println(".")

        catch

            println(" nor openable.")

        end

    end

    return nothing

end
