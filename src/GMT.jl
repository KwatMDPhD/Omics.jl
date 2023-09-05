module GMT

using ..BioLab

function read(gm)

    se_ge_ = Dict{String, Vector{SubString{String}}}()

    for li in eachline(gm)

        sp_ = split(li, '\t')

        se = sp_[1]

        BioLab.Error.error_has_key(se_ge_, se)

        ge_ = filter!(!isempty, view(sp_, 3:length(sp_)))

        BioLab.Error.error_duplicate(ge_)

        se_ge_[se] = ge_

    end

    se_ge_

end

end
