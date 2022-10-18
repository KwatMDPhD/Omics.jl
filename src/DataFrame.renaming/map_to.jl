function map_to(da, co_, de = "|")

    no_ta = Dict()

    id = length(co_)

    for va_ in eachrow(da[!, co_])

        ta = va_[id]

        if ismissing(ta)

            continue

        end

        no_ta[ta] = ta

        for no in va_[1:(id - 1)]

            if ismissing(no)

                continue

            end

            for nos in split(no, de)

                if haskey(no_ta, nos)

                    error("$nos => $(no_ta[nos]) (=> $ta)")

                end

                no_ta[nos] = ta

            end

        end

    end

    no_ta

end
