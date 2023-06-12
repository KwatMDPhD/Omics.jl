module String

using Printf: @sprintf

using ..BioLab

function try_parse(st)

    try

        fl = parse(Float64, st)

        convert(Int, fl)

    catch

    end

    st

end

function format(nu)

    if isequal(nu, -0.0)

        nu = 0.0

    end

    @sprintf "%.4g" nu

end

function title(st)

    ti = ""

    st = strip(st)

    for (up, ch) in zip((isuppercase(ch) for ch in st), titlecase(replace(st, '_' => ' ')))

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
        " st ",
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

function limit(st, n)

    if n < length(st)

        return "$(st[1:n-3])..."

    end

    st

end

function split_get(st, de, id)

    split(st, de; limit = id + 1)[id]

end

function transplant(st1, st2, de, id_)

    sp1_ = split(st1, de)

    sp2_ = split(st2, de)

    BioLab.Array.error_size_difference((sp1_, sp2_))

    join((ifelse(id == 1, sp1, sp2) for (id, sp1, sp2) in zip(id_, sp1_, sp2_)), de)

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

end
