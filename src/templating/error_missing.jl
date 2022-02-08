function error_missing(
    di1,
    di2;
    ig_= Vector{String}(),
    re_= Vector{Pair{String,String}}(),
)

    for (ro, di_, fi_) in walkdir(di1)

        for na in vcat(di_, fi_)

            if na in ig_

                continue

            end

            if 0 < length(re_)

                na = more_string_replace(na, re_)

            end

            pa1 = joinpath(ro, na)

            pa2 = replace(pa1, di1 => di2)

            if !ispath(pa2)

                error("Missing ", pa2)

            end

        end

    end

    return

end
