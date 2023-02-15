function apply!(ve::AbstractVector, fu)

    go_ = [!isnan(nu) for nu in ve]

    if any(go_)

        ve[go_] .= fu(ve[go_])

    end

    nothing

end

function apply!(ma::AbstractMatrix, fu)

    if di == 1

        for (id, nu_) in enumerate(eachrow(ma))

            ma[id, :] .= normalize(nu_, fu)

        end

    elseif di == 2

        for (id, nu_) in enumerate(eachcol(ma))

            ma[:, id] .= normalize(nu_, fu)

        end

    else

        error()

    end

    nothing

end
