module GMT

using ..BioLab

function read(gm)

    se_ge_ = Dict{String, Vector{String}}()

    for li in eachline(gm)

        sp_ = split(li, '\t')

        se = sp_[1]

        BioLab.Error.error_has_key(se_ge_, se)

        se_ge_[se] = filter!(!isempty, sp_[3:end])

    end

    se_ge_

end

end
