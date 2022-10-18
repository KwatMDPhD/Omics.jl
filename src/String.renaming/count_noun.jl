function count_noun(n_st, st)

    if n_st <= 1

        return st

    end

    for (si, pl) in [r"ex$" => "ices", r"ry$" => "ries", r"o$" => "oes"]

        if si == r"ex$" && length(st) <= 3

            return st * "es"

        end

        if contains(st, si)

            return replace(st, si => pl)

        end

    end

    st * "s"

end
