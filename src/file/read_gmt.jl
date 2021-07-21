function read_gmt(pa::String)::Dict{String,Vector{String}}

    se_el_ = Dict{String,Vector{String}}()

    for li in readlines(pa)

        sp_ = split(li, '\t')

        el_ = sp_[3:end]

        if unique(el_) == [""]

            error(li)

        end

        se_el_[sp_[1]] = el_

    end

    return se_el_

end

function read_gmt(pa_::Vector{String})::Dict{String,Vector{String}}

    se_el_ = Dict{String,Vector{String}}()

    for pa in pa_

        merge!(se_el_, read_gmt(pa))

    end

    return se_el_

end

export read_gmt
