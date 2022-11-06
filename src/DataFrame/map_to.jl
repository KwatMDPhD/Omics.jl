function map_to(ro_x_co_x_st, co_, ho = "first"; de = "", pr = true)

    fr_to = Dict()

    id = length(co_)

    for st_ in eachrow(ro_x_co_x_st[!, co_])

        to = st_[id]

        if ismissing(to)

            continue

        end

        OnePiece.Dict.set!(fr_to, to, to, ho, pr = pr)

        for fr in st_[1:(id - 1)]

            if ismissing(fr)

                continue

            end

            if isempty(de)

                fr2_ = ()

            else

                fr2_ = split(fr, de)

            end

            for fr2 in fr2_

                OnePiece.Dict.set!(fr_to, fr2, to, ho, pr = pr)

            end

        end

    end

    fr_to

end
