module GMT

function read(gm)

    se_ge_ = Dict{String, Vector{String}}()

    for li in eachline(gm)

        sp_ = split(li, '\t')

        se = sp_[1]

        if haskey(se_ge_, se)

            error("$se already exists.")

        end

        ge_ = filter!(!isempty, view(sp_, 3:length(sp_)))

        if !allunique(ge_)

            error("$se has duplicated genes.")

        end

        se_ge_[se] = ge_

    end

    se_ge_

end

end
