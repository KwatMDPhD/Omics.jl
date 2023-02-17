module String

using ..BioLab

function print_header()

    println("❀"^99)

    return nothing

end

function print_header(st)

    println("●"^99)

    println(st)

    println("◦"^99)

    return nothing

end

function count_noun(n, st)

    if n <= 1

        return "$n $st"

    end

    for (si, pl) in (("ex", "ices"), ("ry", "ries"), ("o", "oes"))

        if si == "ex" && length(st) <= 3

            return "$n $(st)es"

        end

        sir = Regex("$si\$")

        if contains(st, sir)

            return "$n $(replace(st, sir => pl))"

        end

    end

    return "$n $(st)s"

end

end
