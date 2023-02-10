function map_to(ro_x_co_x_st, fr_, to, ho; de = "", pr = true)

    fr_to = Dict{String, String}()

    for (fr_, to) in zip(
        eachrow(ro_x_co_x_st[!, fr_]),
        ro_x_co_x_st[!, findfirst(co == to for co in names(ro_x_co_x_st))],
    )

        if ismissing(to)

            continue

        end

        BioLab.Dict.set!(fr_to, to, to, ho; pr = pr)

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

                BioLab.Dict.set!(fr_to, fr2, to, ho; pr = pr)

            end

        end

    end

    fr_to

end
