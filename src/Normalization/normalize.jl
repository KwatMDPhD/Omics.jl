using Statistics

using StatsBase

function _normalize(f_::Vector{Float64}, m::String)::Vector{Float64}

    if m == "-0-"

        n_ = (f_ .- mean(f_)) / std(f_)

    elseif m == "0-1"

        m = minimum(f_)

        n_ = (f_ .- m) / (maximum(f_) - m)

    elseif m == "sum"

        if any(f_ .< 0.0)

            error("method sum can not normalize a vector containing any negative number.")

        end

        n_ = f_ / sum(f_)

    elseif m == "1234"

        n_ = ordinalrank(f_)

    elseif m == "1224"

        n_ = competerank(f_)

    elseif m == "1223"

        n_ = denserank(f_)

    elseif m == "1 2.5 2.5 4"

        n_ = tiedrank(f_)

    else

        error("method is not -0-, 0-1, sum, 1234, 1224, 1223, or 1 2.5 2.5 4.")

    end

    return n_

end

function normalize(f_::Vector{Float64}, m::String)::Vector{Float64}

    f_ = copy(f_)

    is_ = .!isnan.(f_)

    if any(is_)

        f_[is_] .= _normalize(f_[is_], m)

    end

    return f_

end

export normalize
