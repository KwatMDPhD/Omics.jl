function merge_recursively(d1::Dict, d2::Dict)::Dict

    d = Dict()

    for k in union(keys(d1), keys(d2))

        if haskey(d1, k) && haskey(d2, k)

            v1 = d1[k]

            v2 = d2[k]

            if isa(v1, Dict) && isa(v2, Dict)

                d[k] = merge_recursively(v1, v2)

            else

                println("$k => ($v1) $v2")

                d[k] = v2

            end

        elseif haskey(d1, k)

            d[k] = d1[k]

        else

            d[k] = d2[k]

        end

    end

    return d

end

export merge_recursively
