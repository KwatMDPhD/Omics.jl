module String

using ..BioLab

function limit(st, n)

    if n < length(st)

        return "$(st[1:n])..."

    end

    st

end

function count_noun(n, st)

    if n <= 1

        return "$n $st"

    end

    if length(st) == 3 && st[2:3] == "ex"

        return "$n $(st)es"

    end

    for (si, pl) in (("ex", "ices"), ("ry", "ries"), ("o", "oes"))

        if endswith(st, si)

            return "$n $(st[1:end-length(si)])$pl"

        end

    end

    "$n $(st)s"

end

function title(st)

    ti = ""

    sts = strip(st)

    for (up, ch) in zip((isuppercase(ch) for ch in sts), titlecase(replace(sts, '_' => ' ')))

        if up

            ch = uppercase(ch)

        end

        ti *= ch

    end

    for lo in (
        "'m ",
        "'re ",
        "'s ",
        "'ve ",
        "'d ",
        " a ",
        " an ",
        " the ",
        " and ",
        " but ",
        " or ",
        " nor ",
        " at ",
        " by ",
        " for ",
        " from ",
        " in ",
        " into ",
        " of ",
        " off ",
        " on ",
        " onto ",
        " out ",
        " over ",
        " to ",
        " up ",
        " with ",
        " as ",
        " vs ",
    )

        ti = replace(ti, titlecase(lo) => lo)

    end

    ti

end

function try_parse(an)

    try

        an = parse(Float64, an)

        an = convert(Int, an)

    catch

    end

    an

end

function split_get(st, de, id)

    split(st, de; limit = id + 1)[id]

end

function remove_common_prefix(st_)

    be = length(BioLab.Collection.get_common_start(st_)) + 1

    (st[be:end] for st in st_)

end

function transplant(st1, st2, de, id_)

    sp1_ = split(st1, de)

    sp2_ = split(st2, de)

    BioLab.Array.error_size_difference((sp1_, sp2_))

    join((ifelse(id == 1, sp1, sp2) for (id, sp1, sp2) in zip(id_, sp1_, sp2_)), de)

end

end
