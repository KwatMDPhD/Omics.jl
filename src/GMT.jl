module GMT

using BioLab

function read(gm)

    se_ge_ = Dict{String, Vector{String}}()

    for li in eachline(gm)

        sp_ = split(li, '\t')

        BioLab.Dict.set!(se_ge_, sp_[1], filter!(!isempty, view(sp_, 3:length(sp_))))

    end

    se_ge_

end

end
