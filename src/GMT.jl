module GMT

using ..BioLab

function read(gm)

    se_ge_ = Dict{String, Vector{String}}()

    for li in eachline(gm)

        sp_ = split(li, '\t')

        BioLab.Dict.set_with_last!(se_ge_, sp_[1], [ge for ge in sp_[3:end] if !isempty(ge)])

    end

    se_ge_

end

end
