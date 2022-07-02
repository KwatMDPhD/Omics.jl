function read(pa::String)

    se_ge_ = Dict()

    for li in readlines(pa)

        sp_ = split(li, "\t")

        se_ge_[sp_[1]] = [ge for ge in sp_[3:end] if !isempty(ge)]

    end

    se_ge_

end

function read(pa_)

    se_ge_ = Dict()

    for pa in pa_

        merge!(se_ge_, read(pa))

    end

    se_ge_

end
