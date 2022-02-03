function map_to_column(da::DataFrame, na_::Vector{String})::Dict{String,String}

    da = da[.!ismissing.(da[!, na_[1]]), :]

    ke_va = Dict{String,String}(va => va for va in da[!, na_[1]])

    for ro in eachrow(da[!, na_])

        va = ro[1]

        for ke_ in skipmissing(ro[2:end])

            for ke in split(ke_, '|')

                if !haskey(ke_va, ke)

                    ke_va[ke] = va

                end

            end

        end

    end

    return ke_va

end
