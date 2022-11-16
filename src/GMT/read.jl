function read(gm::AbstractString)

    se_ge_ = Dict()

    for li in readlines(gm)

        sp_ = split(li, "\t")

        OnePiece.Dict.set!(se_ge_, sp_[1], [ge for ge in sp_[3:end] if !isempty(ge)])

    end

    se_ge_

end

function read(gm_)

    se_ge_ = Dict()

    for gm in gm_

        merge!(se_ge_, read(gm))

    end

    se_ge_

end
