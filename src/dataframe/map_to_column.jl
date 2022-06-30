function map_to_column(da, co_; de = "|")

    n_co = length(co_)

    ta = co_[n_co]

    dad = dropmissing(da, ta)

    ke_va = Dict()

    for va in dad[!, ta]

        ke_va[va] = va

    end

    for ro in eachrow(dad[!, co_])

        va = ro[n_co]

        for ke_ in skipmissing(ro[1:(n_co - 1)])

            for ke in split(ke_, de)

                if !haskey(ke_va, ke)

                    ke_va[ke] = va

                end

            end

        end

    end

    ke_va

end
