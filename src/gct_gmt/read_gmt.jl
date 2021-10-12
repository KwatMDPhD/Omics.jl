function read_gmt(pa::String)::Dict{String, Vector{String}}

    se_ge_ = Dict{String, Vector{String}}()

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

function read_gmt(pa_::Vector{String})::Dict{String, Vector{String}}

    se_ge_ = Dict{String, Vector{String}}()

    for pa in pa_

        merge!(se_ge_, read_gmt(pa))

    end

    return se_ge_

end

export read_gmt
