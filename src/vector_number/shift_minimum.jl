function shift_minimum(te, mi)

    if isa(mi, String) && endswith(mi, "<")

        mi = minimum(te[parse(Float64, split(mi, "<")[1]) .< te])

    end

    te .+ (mi - minimum(te))

end
