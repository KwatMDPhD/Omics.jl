using ..dictionary: merge

Ty = Dict{String, Vector{String}}

function read_gmt(pa::String)::Ty

    se_ge_ = Ty()

    for li in readlines(pa)

        sp_ = split(li, '\t')

        ge_ = sp_[3:end]

        if unique(ge_) == [""]

            #println("$(sp_[1]) is empty.")

        else

            se_ge_[sp_[1]] = ge_

        end


    end

    return se_ge_

end

function read_gmt(pa_::Vector{String})::Ty

    se_ge_ = Ty()

    for pa in pa_

        se_ge_ = merge(se_ge_, read_gmt(pa))

    end

    return se_ge_

end

export read_gmt
