function _sum_where_1(ve::Vector{Float64}, wh_::Vector{Float64})::Float64

    su = 0.0

    for (ie, wh) in enumerate(wh_)

        if wh == 1.0

            su += ve[ie]

        end

    end

    return su

end

function _sum_where_2(ve::Vector{Float64}, wh_::Vector{Float64})::Float64

    su = 0.0

    for (fl, wh) in zip(ve, wh_)

        if wh == 1.0

            su += fl

        end

    end

    return su

end

function sum_where(ve::Vector{Float64}, wh_::Vector{Float64})::Float64

    if length(ve) < 3000

        return _sum_where_1(ve, wh_)

    else

        return _sum_where_2(ve, wh_)

    end

end

export sum_where
