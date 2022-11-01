function read(gs, di = OnePiece.TE)

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

    ket = "an_"

    #
    for li in split(Base.read(open(gz, "r"), String), "\n")[1:(end - 1)]

        #
        if startswith(li, "^")

            println(li)

            ty, bl = split(li[2:end], eq, limit = 2)

            get!(ty_bl, ty, OrderedDict())[bl] = OrderedDict()

            continue

        end

        ke_va = ty_bl[ty][bl]

        #
        if statswith(li, "!$(lowercase(ty))_table_")

            if endswith(li, "begin")

                ke_va[ket] = []

            elseif endswith(li, "end")

                fe_x_in_x_an = OnePiece.DataFrame.make(pop!(ke_va, ket))

                if size(fe_x_in_x_an, 1) !=
                   parse(Int, pop!(ke_va, "!$(titlecase(ty))_data_row_count"))

                    error()

                end

                ke_va["fe_x_in_x_an"] = fe_x_in_x_an

            else

                error()

            end

            continue

        end

        #
        if haskey(ke_va, ket)

            push!(ke_va[ket], split(li, "\t"))

        else

            OnePiece.Dict.set!(ke_va, split(li, eq, limit = 2), "suffix")

        end

    end

    ty_bl

end
