function rename(st_, wh_ = ("mouse", "ensembl", "hgnc"))

    #
    st_na = Dict()

    if "mouse" in wh_

        merge!(st_na, map_mouse())

    end
    for wh in ("ensembl", "hgnc")

        if wh in wh_

            merge!(st_na, map_to(wh))

        end

    end

    #
    na_ = []

    ma_ = []

    for st in st_

        if haskey(st_na, st)

            na = st_na[st]

            push!(na_, na)

            push!(ma_, 2 - (st == na))

        else

            push!(na_, st)

            push!(ma_, 3)

        end

    end

    #
    n_ = [0.0, 0.0, 0.0]

    for ma in ma_

        n_[ma] += 1.0

    end

    for (id, em) in ((1, "👍"), (2, "✌️"), (3, "👎"))

        println("$em $(convert(Int, n_[id]))")

    end

    na_, ma_

end
