function make(di, so_, sc, ht = "")

    if isempty(ht)

        ht = joinpath(OnePiece.TE, "$(OnePiece.Time.stamp()).html")

    end

    li_ = vcat(
        "<!doctype html>",
        "<div id=\"$di\" style=\"display: block; height: 800px; width: 90%; margin: auto; background: #f8f8f8\"></div>",
        ["<script src=\"$so\"></script>" for so in so_],
        "<script>",
        "$sc",
        "</script>",
    )

    jo = join(li_, "\n")

    open(ht, "w") do io

        write(io, jo)

    end

    println("Wrote $ht.")

    display(Base.HTML(jo))

end
