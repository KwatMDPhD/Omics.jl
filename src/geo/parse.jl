function parse(gs; di = OnePiece.TEMPORARY_DIRECTORY)

    fi = "$(gs)_family.soft.gz"

    pa = joinpath(di, fi)

    if ispath(pa)

        println("Using $pa")

    else

        download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs[1:end-3])nnn/$gs/soft/$fi", pa)

    end

    ty = nothing

    bl = nothing

    ty_bl = Dict()

    eq = " = "

    for li in split(read(GZip.open(pa, "r"), String), '\n')[1:(end - 1)]

        if startswith(li, '^')

            println(li)

            ty, bl = split(li[2:end], eq, limit = 2)

            get!(ty_bl, ty, OrderedDict())[bl] = OrderedDict()

            continue

        end

        ke_va = ty_bl[ty][bl]

        ta = "!$(lowercase(ty))_table_"

        if li == "$(ta)begin"

            ke_va["ro_"] = []

            continue

        elseif li == "$(ta)end"

            da = OnePiece.data_frame.make(pop!(ke_va, "ro_"))

            if Base.parse(Int, ke_va["!$(titlecase(ty))_data_row_count"]) != size(da, 1)

                error()

            end

            ke_va["da"] = da

            continue

        end

        if haskey(ke_va, "ro_")

            push!(ke_va["ro_"], split(li, '\t'))

        else

            ke, va = split(li, eq, limit = 2)

            n_du = 1

            while haskey(ke_va, ke)

                if n_du == 1

                    ke = "$ke.1"

                end

                ke = replace(ke, Regex(".$n_du\$") => ".$(n_du+=1)")

            end

            ke_va[ke] = va

        end

    end

    ty_bl

end
