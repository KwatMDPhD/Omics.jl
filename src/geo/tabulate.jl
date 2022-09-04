function tabulate(ty_bl, sa = "!Sample_title")

    sa_di = OrderedDict(di[sa] => di for di in values(ty_bl["SAMPLE"]))

    sa_an = OrderedDict()

    pl_ = []

    sa_nu = OrderedDict()

    de = ": "

    for (sa, di) in sa_di

        ch_ = [va for (ke, va) in di if startswith(ke, "!Sample_characteristics")]

        if all([contains(ch, de) for ch in ch_])

            sp_ = [split(ch, de, limit = 2) for ch in ch_]

            pr_ = [sp[1] for sp in sp_]

            if get!(sa_an, "Feature", pr_) != pr_

                error()

            end

            sa_an[sa] = [sp[2] for sp in sp_]

        else

            println("$sa characteristic lacks \"$de\":\n$(join(ch_, '\n'))")

        end

        push!(pl_, di["!Sample_platform_id"])

        if haskey(di, "da")

            da = di["da"]

            fe_ = da[!, 1]

            cu_ = get!(sa_nu, "Feature", fe_)

            if cu_ == fe_

                id_ = 1:size(da, 1)

            else

                println("$sa table rows do not match. Sorting")

                id_ = indexin(cu_, fe_)

            end

            sa_nu[sa] = da[id_, "VALUE"]

        else

            println("$sa table is empty.")

        end

    end

    pl_di = ty_bl["PLATFORM"]

    unique!(pl_)

    if isempty(pl_)

        println("Sample platforms are empty. Using the first")

        pl = collect(keys(pl_di))[1]

    elseif length(pl_) == 1

        pl = pl_[1]

    else

        error()

    end

    if haskey(pl_di[pl], "da")

        fe_na = name(pl, pl_di[pl]["da"])

        sa_nu["Feature"] = [get(fe_na, fe, "") for fe in sa_nu["Feature"]]

    else

        println("$pl table is empty.")

    end

    fe_x_sa_x_an = DataFrame(sa_an)

    fe_x_sa_x_nu = DataFrame(sa_nu)

    OnePiece.data_frame.print_unique(eachrow(fe_x_sa_x_an))

    fe_x_sa_x_an, fe_x_sa_x_nu

end
