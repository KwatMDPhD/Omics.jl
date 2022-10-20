function read(gs, di = OnePiece.TEMPORARY_DIRECTORY)

    #
    fi = "$(gs)_family.soft.gz"

    gz = joinpath(di, fi)

    if ispath(gz)

        println("Using $gz")

    else

        download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs[1:end-3])nnn/$gs/soft/$fi", gz)

    end

    #
    ty = nothing

    bl = nothing

    ty_bl = Dict()

    eq = " = "

    #
    for li in split(Base.read(open(gz, "r"), String), '\n')[1:(end - 1)]

        #
        if startswith(li, '^')

            println(li)

            ty, bl = split(li[2:end], eq, limit = 2)

            get!(ty_bl, ty, OrderedDict())[bl] = OrderedDict()

            continue

        end

        ke_va = ty_bl[ty][bl]

        ta = "!$(lowercase(ty))_table_"

        #
        if li == "$(ta)begin"

            ke_va["ro_"] = []

            continue

        elseif li == "$(ta)end"

            da = OnePiece.DataFrame.make(pop!(ke_va, "ro_"))

            if parse(Int, pop!(ke_va, "!$(titlecase(ty))_data_row_count")) != size(da, 1)

                error()

            end

            ke_va["da"] = da

            continue

        end

        #
        if haskey(ke_va, "ro_")

            push!(ke_va["ro_"], split(li, '\t'))

        else

            OnePiece.Dict.set!(ke_va, Pair(split(li, eq, limit = 2)), "suffix")

        end

    end

    ty_bl

end
