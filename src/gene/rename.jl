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

    na_ = Vector{String}()

    ma_ = Vector{Int}()

    for st in st_

        if haskey(st_na, st)

            na = st_na[st]

            push!(na_, na)

            push!(ma_, 1 - (st == na))

        else

            push!(na_, st)

            push!(ma_, 2)

        end

    end

    println("Kept $(count(ma_ .== 0))")

    println("Named $(count(ma_ .== 1))")

    println("Failed $(count(ma_ .== 2))")

    na_, ma_

end
