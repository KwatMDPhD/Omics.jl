function get_p_value(fl::Float64, ra_::Vector{Float64}, si::String)::Float64

    if si == "<"

        si_ = ra_ .<= fl

    elseif si == ">"

        si_ = fl .<= ra_

    end

    return maximum((1, sum(si_))) / length(ra_)

end

export get_p_value
