function map_to_column(da, co_; de = "|")

    n_co = length(co_)

    ta = co_[n_co]

    da2 = dropmissing(da, ta)

    ke_va = Dict()

    for va in da2[!, ta]

        ke_va[va] = va

    end

    for ro in eachrow(da2[!, co_])

        va = ro[n_co]

        for ke_ in skipmissing(ro[1:(n_co - 1)])

            for ke in split(ke_, de)

                if !haskey(ke_va, ke)

                    ke_va[ke] = va

                end

            end

        end

    end

    summarize(ke_va)

    ke_va

end
