using StatsBase: mean
using Statistics: std
using StatsBase: competerank, denserank, ordinalrank, tiedrank

function normalize(ve::Vector{Float64}, me::String)::Vector{Float64}

    if me == "-0-"

        return (ve .- mean(ve)) / std(ve)

    elseif me == "0-1"

        me = minimum(ve)

        return (ve .- me) / (maximum(ve) - me)

    elseif me == "sum"

        if any(ve .< 0.0)

            error(
                "method sum can not normalize a vector containing any negative number.",
            )

        else

            return ve / sum(ve)

        end

    elseif me == "1234"

        return ordinalrank(ve)

    elseif me == "1224"

        return competerank(ve)

    elseif me == "1223"

        return denserank(ve)

    elseif me == "1 2.5 2.5 4"

        return tiedrank(ve)

    end

end

export normalize
