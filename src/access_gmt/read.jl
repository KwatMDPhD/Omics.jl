function read(pa::String)::Dict{String,Vector{String}}

    se_ge_ = Dict{String,Vector{String}}()

    for li in readlines(pa)

        sp_ = split(li, '\t')

        se = sp_[1]

        ge_ = [ge for ge in sp_[3:end] if ge != ""]

        if length(ge_) == 0

            println(se, " is empty")

        else

            se_ge_[se] = ge_

        end


    end

    return se_ge_

end

function read(pa_::Vector{String})::Dict{String,Vector{String}}

    se_ge_ = Dict{String,Vector{String}}()

    for pa in pa_

        merge!(se_ge_, read(pa))

    end

    return se_ge_

end
