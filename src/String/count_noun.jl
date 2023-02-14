function count_noun(n, st)

    if n <= 1

        return st

    end

    for (si, pl) in (("ex", "ices"), ("ry", "ries"), ("o", "oes"))

        if si == "ex" && length(st) <= 3

            return st * "es"

        end

        sir = Regex("$si\$")

        if contains(st, sir)

            return replace(st, sir => pl)

        end

    end

    st * "s"

end
