function rename(st_; mo = true, en = true, hg = true)

    st_na = Dict()

    if mo

        merge!(st_na, map_from_mouse())

    end

    if en

        merge!(st_na, map_to_ensembl())

    end

    if hg

        merge!(st_na, map_to_hgnc())

    end

    na_ = String[]

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

    println("🤞 $(count(ma_ .== 2))")

    println("👎 $(count(ma_ .== 3))")

    na_, ma_

end
