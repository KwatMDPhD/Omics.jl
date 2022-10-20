function make(
    di,
    sr_,
    sc,
    ht = joinpath(OnePiece.TEMPORARY_DIRECTORY, "$(OnePiece.Time.stamp()).html"),
)

    li_ = vcat(
        "<!doctype html>",
        "<div id=\"$di\" style=\"display: block; height: 800px; width: 80%; margin-left: auto; margin-right: auto; background: #fdfdfd\"></div>",
        ["<script src=\"$sr\"></script>" for sr in sr_],
        "<script>",
        "$sc",
        "</script>",
    )

    jo = join(li_, "\n")

    open(ht, "w") do io

        write(io, jo)

    end

    println("Wrote $ht.")

    Base.HTML(jo)

end
