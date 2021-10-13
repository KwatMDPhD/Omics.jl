function merge(di1::Dict, di2::Dict)::Dict

    di = Dict()

    for ke in union(keys(di1), keys(di2))

        if haskey(di1, ke) && haskey(di2, ke)

            va1 = di1[ke]

            va2 = di2[ke]

            if isa(va1, Dict) && isa(va2, Dict)

                va = merge(va1, va2)

            else

                println(ke, " => (", va1, ") ", va2, ".")

                va = va2

            end

        elseif haskey(di1, ke)

            va = di1[ke]

        else

            va = di2[ke]

        end

        di[ke] = va

    end

    return di

end

export merge
