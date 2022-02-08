function error_missing(
    dit,
    di;
    ig_= [],
    re_= [],
)

    for (ro, di_, fi_) in walkdir(dit)

        for na in vcat(di_, fi_)

            if na in ig_

                continue

            end

            if !isempty(re_)

                na = string_replace(na, re_)

            end

            pa = replace(joinpath(ro, na), dit => di)

            if !ispath(pa)

                error("missing ", pa)

            end

        end

    end

end
