function tabulate(ty_bl)

    ch_pr = Dict()

    de = ": "

    sa_su = Dict()

    for (sa, di) in ty_bl["SAMPLE"]

        if isempty(ch_pr)

            ch_ = [fe for fe in keys(di) if startswith(fe, "!Sample_characteristics")]

            an_ = [di[ch] for ch in ch_]

            if !all(contains.(an_, de))

                println("Bad characteristics:\n$(join(an_, '\n'))\n")

                continue

            end

            sp_ = [split(an, de, limit = 2) for an in an_]

            ch_pr = Dict(zip(ch_, (sp[1] for sp in sp_)))

            sa_su[sa] = [sp[2] for sp in sp_]

            continue

        end

        su_ = []

        for (ch, pr) in ch_pr

            pr2, su = split(di[ch], de, limit = 2)

            if pr == pr2

                push!(su_, su)

            else

                error()

            end

        end

        sa_su[sa] = su_

    end

    fe_x_sa_x_an = DataFrame(Dict("Feature" => collect(values(ch_pr)), sa_su...))

    pl = ""

    fe_ = []

    sa_nu = Dict()

    for (sa, di) in ty_bl["SAMPLE"]

        if isempty(pl)

            pl = di["!Sample_platform_id"]

        elseif pl != di["!Sample_platform_id"]

            error()

        end

        if !haskey(di, "da")

            println("Data frame is empty.")

            continue

        end

        da = di["da"]

        fe2_ = da[!, 1]

        if isempty(fe_)

            fe_ = fe2_

        elseif !all(fe2_ .== fe_)

            println("Sorting sample table")

            id_ = []

            for fe in fe_

                fo_ = findall(fe2_ .== fe)

                if length(fo_) != 1

                    error()

                end

                push!(id_, fo_[1])

            end

            da = da[id_, :]

        end

        sa_nu[sa] = da[!, "VALUE"]

    end

    pl_di = ty_bl["PLATFORM"]

    if isempty(pl)

        println("Sample platforms are not specified. Using the first")

        pl = collect(keys(pl_di))[1]

    end

    if haskey(pl_di[pl], "da")

        fe_na = name(pl, pl_di[pl]["da"])

        fe_ = [get(fe_na, fe, nothing) for fe in fe_]

    else

        println("Platform table is empty.")

    end

    fe_x_sa_x_nu = DataFrame(Dict("Feature" => fe_, sa_nu...))

    fe_x_sa_x_an, fe_x_sa_x_nu

end
