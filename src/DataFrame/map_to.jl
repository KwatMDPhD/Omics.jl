function map_to(ro_x_co_x_st, ho, fr_, to; de = "")

    fr_to = Dict{String, String}()

    for (fr_, to) in zip(
        eachrow(ro_x_co_x_st[!, fr_]),
        ro_x_co_x_st[!, findfirst(co == to for co in names(ro_x_co_x_st))],
    )

        if ismissing(to)

            continue

        end

        ho(fr_to, to, to)

        for fr in fr_

            if ismissing(fr)

                continue

            end

            if isempty(de)

                fr2_ = [fr]

            else

                fr2_ = split(fr, de)

            end

            for fr2 in fr2_

                ho(fr_to, fr2, to)

            end

        end

    end

    return fr_to

end
