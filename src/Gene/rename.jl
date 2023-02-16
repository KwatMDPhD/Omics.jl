function rename(st_; mo = true, en = true, hg = true)

    st_na = Dict{String, String}()

    if mo

        merge!(st_na, map_mouse())

    end

    if en

        merge!(st_na, map_ensemble())

    end

    if hg

        merge!(st_na, map_hgnc())

    end

    n = length(st_)

    na_ = Vector{String}(undef, n)

    ma_ = Vector{Int}(undef, n)

    n_1 = 0

    n_2 = 0

    n_3 = 0

    for id in 1:n

        if haskey(st_na, st)

            na = st_na[st]

            if st == na

                ma = 1

                n_1 += 1

            else

                ma = 2

                n_2 += 1

            end

        else

            na = st

            ma = 3

            n_3 += 1

        end

        na_[id] = na

        ma_[id] = ma

    end

    for (n, em) in ((n_1, "👍"), (n_2, "✅"), (n_3, "❌"))

        println("$em $n")

    end

    return na_, ma_

end
