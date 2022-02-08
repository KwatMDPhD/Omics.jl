function shift_minimum(ve, mi)

    if isa(mi, String) && endswith(mi, "<")

        mi = minimum(ve[parse(Float64, split(mi, "<")[1]).<ve])

    end

    return ve .+ (mi - minimum(ve))

end
