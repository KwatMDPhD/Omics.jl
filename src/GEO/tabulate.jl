function _name(pl, da)

    pl = parse(Int, pl[4:end])

    fu = na -> na

    ke = "ID"

    if pl in [96, 97, 570]

        va = "Gene Symbol"

        fu = na -> OnePiece.String.split_and_get(na, " /// ", 1)

    elseif pl in [13534]

        va = "UCSC_RefGene_Name"

        fu = na -> OnePiece.String.split_and_get(na, ";", 1)

    elseif pl in [5175, 11532]

        va = "gene_assignment"

        fu = na -> OnePiece.String.split_and_get(na, " // ", 2)

    elseif pl in [2004, 2005, 3718, 3720]

        va = "Associated Gene"

        fu = na -> OnePiece.String.split_and_get(na, " // ", 1)

    elseif pl in [10558]

        va = "Symbol"

    elseif pl in [16686]

        va = "GB_ACC"

    end

    println(first(da, 4))

    println("$ke => $va")

    fe_na = Dict()

    for (fe, na) in zip(da[!, ke], da[!, va])

        if na isa AbstractString && !isempty(na) && !(na in ["---"])

            OnePiece.Dict.set!(fe_na, fe => fu(na))

        end

    end

    OnePiece.Dict.print(fe_na, 0)

    fe_na

end

function tabulate(ty_bl, sa = "!Sample_title")

    #
    sa_di = OrderedDict(pop!(di, sa) => di for di in values(ty_bl["SAMPLE"]))

    naf = "Feature"

    #
    de = ": "

    sa_an = OrderedDict()

    #
    pl_ = []

    sa_nu = OrderedDict()

    #
    for (sa, di) in sa_di

        #
        ch_ = [va for (ke, va) in di if startswith(ke, "!Sample_characteristics")]

        if all([contains(ch, de) for ch in ch_])

            sp_ = [split(ch, de, limit = 2) for ch in ch_]

            pr_ = [sp[1] for sp in sp_]

            if get!(sa_an, naf, pr_) != pr_

                error()

            end

            OnePiece.Dict.set!(sa_an, sa => [sp[2] for sp in sp_])

        else

            println("$sa characteristic lacks \"$de\":\n  $(join(ch_, "\n  "))")

        end

        #
        push!(pl_, di["!Sample_platform_id"])

        #
        if haskey(di, "da")

            da = di["da"]

            fe_ = da[!, 1]

            cu_ = get!(sa_nu, naf, fe_)

            if cu_ == fe_

                id_ = 1:size(da, 1)

            else

                println("$sa table rows do not match. Sorting")

                id_ = indexin(cu_, fe_)

            end

            OnePiece.Dict.set!(sa_nu, sa => [parse(Float64, va) for va in da[id_, "VALUE"]])

        else

            println("$sa table is empty.")

        end

    end

    #
    fe_x_sa_x_an = DataFrame(sa_an)

    OnePiece.DataFrame.print_unique(fe_x_sa_x_an)

    #
    fe_x_sa_x_nu = DataFrame(sa_nu)

    pl_di = ty_bl["PLATFORM"]

    #
    unique!(pl_)

    if isempty(pl_)

        println("Sample platforms are empty. Using the first")

        pl = collect(keys(pl_di))[1]

    elseif length(pl_) == 1

        pl = pl_[1]

    else

        error()

    end

    #
    if haskey(pl_di[pl], "da")

        fe_na = _name(pl, pl_di[pl]["da"])

        fe_x_sa_x_nu[!, naf] = [get(fe_na, fe, "") for fe in fe_x_sa_x_nu[!, naf]]

        rename!(fe_x_sa_x_nu, naf => "Gene")

    else

        println("$pl table is empty.")

    end

    #
    fe_x_sa_x_an, fe_x_sa_x_nu

end
