function merge(di1, di2)

    di = Dict()

    for ke in union(keys(di1), keys(di2))

        if haskey(di1, ke) && haskey(di2, ke)

            va1 = di1[ke]

            va2 = di2[ke]

            if isa(va1, AbstractDict) && isa(va2, AbstractDict)

                va = merge(va1, va2)

            else

                if va1 != va2

                    println("$ke => ($va1) $va2")

                end

                va = va2

            end

        elseif haskey(di1, ke)

            va = di1[ke]

        else

            va = di2[ke]

        end

        if isa(va, AbstractDict)

            va = copy(va)

        end

        di[ke] = va

    end

    di

end
