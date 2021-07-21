function merge(di1::Dict, di2::Dict)::Dict

    di = Dict()

    for ke in union(keys(di1), keys(di2))

        if haskey(di1, ke) && haskey(di2, ke)

            va1 = di1[ke]

            va2 = di2[ke]

            if isa(va1, Dict) && isa(va2, Dict)

                di[ke] = merge(va1, va2)

            else

                println("$ke => ($va1) $va2")

                di[ke] = va2

            end

        elseif haskey(di1, ke)

            di[ke] = di1[ke]

        else

            di[ke] = di2[ke]

        end

    end

    return di

end

export merge
