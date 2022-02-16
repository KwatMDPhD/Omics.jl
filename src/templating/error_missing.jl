function error_missing(te, di; ig_ = [], re_ = [])

    mi_ = []

    for (ro, di_, fi_) in walkdir(te)

        for na in vcat(di_, fi_)

            if any(occursin.(ig_, joinpath(ro, na)))

                continue

            end

            if !isempty(re_)

                na = replace(na, re_...)

            end

            pa = joinpath(replace(ro, te => di), na)

            if !ispath(pa)

                push!(mi_, pa)

            end

        end

    end

    if !isempty(mi_)

        se = "\n\t"

        error("missing$se$(join(mi_, se))")

    end

end
