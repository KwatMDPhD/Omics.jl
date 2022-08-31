function rename(fe_, pl, da)

    pl = parse(Int, pl[4:end])

    fu = (na) -> na

    ke = "ID"

    if pl in [96, 97, 570]

        va = "Gene Symbol"

        fu = (na) -> split(na, " /// ", limit = 2)[1]

    elseif pl in [13534]

        va = "UCSC_RefGene_Name"

        fu = (na) -> split(na, ';', limit = 2)[1]

    elseif pl in [5175, 11532]

        va = "gene_assignment"

        fu = (na) -> split(na, " // ", limit = 2)[2]

    elseif pl in [2004, 2005, 3718, 3720]

        va = "Associated Gene"

        fu = (na) -> split(na, " // ", limit = 2)[1]

    elseif pl in [10558]

        va = "Symbol"

    elseif pl in [16686]

        va = "GB_ACC"

    end

    n_pe = 8

    println(first(da, n_pe))

    println("$ke => $va")

    fe_na = Dict()

    for (fe, na) in zip(da[!, ke], da[!, va])

        if na isa AbstractString && !isempty(na) && !(na in ["---"])

            fe_na[fe] = fu(na)

        end

    end

    OnePiece.dict.print(fe_na, n_pa = n_pe)

    [Base.get(fe_na, fe, fe) for fe in fe_]

end

function tabulate(ty_bl)

    an = DataFrame()

    pl = ""

    fe_ = []

    sa_nu = Dict()

    for (sa, di) in ty_bl["SAMPLE"]

        if isempty(pl)

            pl = di["!Sample_platform_id"]

        elseif pl != di["!Sample_platform_id"]

            error()

        end

        da = di["da"]

        if isempty(fe_)

            fe_ = da[!, 1]

        elseif !all(fe_ .== da[!, 1])

            error()

        end

        sa_nu[sa] = da[!, "VALUE"]

    end

    nu = DataFrame(Dict("Feature" => rename(fe_, pl, ty_bl["PLATFORM"][pl]["da"]), sa_nu...))

    an, nu

end
