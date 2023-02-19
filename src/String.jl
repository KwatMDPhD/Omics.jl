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

function limit(st, n)

    if n < length(st)

        return "$(st[1:n])..."

    else

        return st

    end

end

function count_noun(n, st)

    if n <= 1

        return "$n $st"

    end

    if length(st) == 3 && st[2:3] == "ex"

        return "$n $(st)es"

    end

    for (si, pl) in (("ex", "ices"), ("ry", "ries"), ("o", "oes"))

        sir = Regex("$si\$")

        if contains(st, sir)

            return "$n $(replace(st, sir => pl))"

        end

    end

    return "$n $(st)s"

end

function title(st)

    st = strip(st)

    ti = ""

    for (up, ch) in zip((isuppercase(ch) for ch in st), titlecase(replace(st, '_' => ' ')))

        if up

            ch = uppercase(ch)

        end

        ti *= ch

    end

    for lo in (
        "a",
        "an",
        "the",
        "and",
        "but",
        "or",
        "nor",
        "at",
        "by",
        "for",
        "from",
        "in",
        "into",
        "of",
        "off",
        "on",
        "onto",
        "out",
        "over",
        "to",
        "up",
        "with",
        "as",
        "vs",
    )

        ti = replace(ti, " $(titlecase(lo)) " => " $lo ")

    end

    # TODO: Time ''.
    for sh in ("m", "re", "s", "ve", "d")

        ti = replace(ti, "'$(titlecase(sh)) " => "'$sh ")

    end

    return ti

end

# TODO: Time without `limit`.
function split_and_get(st, de, id)

    return split(st, de; limit = id + 1)[id]

end

function remove_common_prefix(st_)

    n = length(BioLab.Vector.get_common_start(st_))

    return [st[(n + 1):end] for st in st_]

end

function transplant(st1, st2, de, id_)

    sp1_ = split(st1, de)

    sp2_ = split(st2, de)

    BioLab.Array.error_size(sp1_, sp2_)

    # TODO: Time with `ifelse`.
    return join(((sp1, sp2)[id] for (sp1, sp2, id) in zip(sp1_, sp2_, id_)), de)

end

end
