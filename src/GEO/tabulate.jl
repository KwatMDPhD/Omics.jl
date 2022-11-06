function _name(pl, fe_x_in_x_an)

    pl = parse(Int, pl[4:end])

    ke = "ID"

    if pl in (96, 97, 570)

        va = "Gene Symbol"

        fu = na -> OnePiece.String.split_and_get(na, " /// ", 1)

    elseif pl == 13534

        va = "UCSC_RefGene_Name"

        fu = na -> OnePiece.String.split_and_get(na, ";", 1)

    elseif pl in (5175, 11532)

        va = "gene_assignment"

        fu = na -> OnePiece.String.split_and_get(na, " // ", 2)

    elseif pl in (2004, 2005, 3718, 3720)

        va = "Associated Gene"

        fu = na -> OnePiece.String.split_and_get(na, " // ", 1)

    elseif pl == 10558

        va = "Symbol"

        fu = na -> na

    elseif pl == 16686

        va = "GB_ACC"

        fu = na -> na

    else

        error()

    end

    println(first(fe_x_in_x_an, 4))

    println("$ke => $va")

    fe_na = Dict()

    for (fe, na) in zip(fe_x_in_x_an[!, ke], fe_x_in_x_an[!, va])

        if na isa AbstractString && !isempty(na) && !(na in ("---",))

            OnePiece.Dict.set!(fe_na, fe, fu(na))

        end

    end

    OnePiece.Dict.print(fe_na, 0)

    fe_na

end

function tabulate(ty_bl, sa = "!Sample_title")

    #
    sa_ke_va = OrderedDict(pop!(ke_va, sa) => ke_va for ke_va in values(ty_bl["SAMPLE"]))

    ro = "Feature"

    #
    de = ": "

    sa_an_ = OrderedDict()

    #
    pl_ = []

    sa_nu_ = OrderedDict()

    #
    for (sa, ke_va) in sa_ke_va

        #
        ch_ = [va for (ke, va) in ke_va if startswith(ke, "!Sample_characteristics")]

        if all(occursin(de, ch) for ch in ch_)

            sp_ = [split(ch, de, limit = 2) for ch in ch_]

            pr_ = [sp[1] for sp in sp_]

            if get!(sa_an_, ro, pr_) != pr_

                error()

            end

            OnePiece.Dict.set!(sa_an_, sa, [sp[2] for sp in sp_])

        else

            println("A $sa characteristic lacks \"$de\":\n  $(join(ch_, "\n  "))")

        end

        #
        push!(pl_, ke_va["!Sample_platform_id"])

        #
        if haskey(ke_va, "fe_x_in_x_an")

            fe_x_in_x_an = ke_va["fe_x_in_x_an"]

            fe_ = fe_x_in_x_an[!, 1]

            cu_ = get!(sa_nu_, ro, fe_)

            if cu_ == fe_

                id_ = 1:size(fe_x_in_x_an, 1)

            else

                println("$sa table rows do not match. Sorting")

                id_ = indexin(cu_, fe_)

            end

            OnePiece.Dict.set!(
                sa_nu_,
                sa,
                [parse(Float64, va) for va in fe_x_in_x_an[id_, "VALUE"]],
            )

        else

            println("$sa table is empty.")

        end

    end

    #
    fe_x_sa_x_an = DataFrame(sa_an_)

    OnePiece.DataFrame.print_unique(fe_x_sa_x_an)

    #
    fe_x_sa_x_nu = DataFrame(sa_nu_)

    pl_ke_va = ty_bl["PLATFORM"]

    #
    unique!(pl_)

    if isempty(pl_)

        println("Sample platforms are empty. Using the first")

        pl = collect(keys(pl_ke_va))[1]

    elseif length(pl_) == 1

        pl = pl_[1]

    else

        error()

    end

    #
    if haskey(pl_ke_va[pl], "fe_x_in_x_an")

        fe_na = _name(pl, pl_ke_va[pl]["fe_x_in_x_an"])

        fe_x_sa_x_nu[!, ro] = [get(fe_na, fe, "_$fe") for fe in fe_x_sa_x_nu[!, ro]]

        rename!(fe_x_sa_x_nu, ro => "Gene")

    else

        println("$pl table is empty.")

    end

    #
    fe_x_sa_x_an, fe_x_sa_x_nu

end
