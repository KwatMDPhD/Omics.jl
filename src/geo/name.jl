function name(pl, da)

    pl = Base.parse(Int, pl[4:end])

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

    println(first(da, 4))

    println("$ke => $va")

    fe_na = Dict()

    for (fe, na) in zip(da[!, ke], da[!, va])

        if na isa AbstractString && !isempty(na) && !(na in ["---"])

            fe_na[fe] = fu(na)

        end

    end

    OnePiece.dict.print(fe_na, n_pa = 0)

    fe_na

end
