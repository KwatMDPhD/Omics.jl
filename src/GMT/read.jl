function read(gm::AbstractString)

    se_ge_ = Dict{String, Vector{String}}()

    for li in readlines(gm)

        sp_ = split(li, '\t')

        BioLab.Dict.set_with_last!(se_ge_, sp_[1], [ge for ge in sp_[3:end] if !isempty(ge)])

    end

    return se_ge_

end

function read(gm_)

    se_ge_ = Dict{String, Vector{String}}()

    for gm in gm_

        merge!(se_ge_, read(gm))

    end

    return se_ge_

end
