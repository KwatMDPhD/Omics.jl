function make(di, sr_, sc, ht = "")

    if isempty(ht)

        ht = joinpath(OnePiece.TEMPORARY_DIRECTORY, "$(OnePiece.time.stamp()).html")

    end

    li_ = [
        "<!doctype html>",
        "<div id=\"$di\" style=\"display: block; height: 800; width: 100%; margin-left: auto; margin-right: auto; background: #fdfdfd\"></div>",
        ["<script src=\"$sr\"></script>" for sr in sr_]...,
        "<script>",
        "$sc",
        "</script>",
    ]

    jo = join(li_, '\n')

    open(ht, "w") do io

        write(io, jo)

    end

    println("Wrote $ht.")

    HTML(jo)

end
