function map_to(da, co_, de = "|"; pr = true)

    no_ta = Dict()

    id = length(co_)

    for va_ in eachrow(da[!, co_])

        ta = va_[id]

        if ismissing(ta)

            continue

        end

        OnePiece.Dict.set!(no_ta, ta => ta, pr)

        for no in va_[1:(id - 1)]

            if ismissing(no)

                continue

            end

            for nos in split(no, de)

                OnePiece.Dict.set!(no_ta, nos => ta, pr)

            end

        end

    end

    no_ta

end
