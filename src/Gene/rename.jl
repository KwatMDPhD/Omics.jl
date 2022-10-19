function rename(st_, wh_ = ["mouse", "ensembl", "hgnc"])

    st_na = Dict()

    if "mouse" in wh_

        merge!(st_na, map_mouse())

    end

    for wh in ["ensembl", "hgnc"]

        if wh in wh_

            merge!(st_na, map_to(wh))

        end

    end

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

    println("👍 $(count(ma_ .== 1))")

    println("✌️ $(count(ma_ .== 2))")

    println("👎 $(count(ma_ .== 3))")

    na_, ma_

end
