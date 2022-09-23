function title(st)

    st = replace(st, "_" => " ")

    up_ = [isuppercase(ch) for ch in st]

    st = titlecase(st)

    st2 = ""

    for (up, ch) in zip(up_, st)

        if up

            ch = uppercase(ch)

        end

        st2 *= ch

    end

    st = st2

    for lo in [
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
    ]

        st = replace(st, " $(titlecase(lo)) " => " $lo ")

    end

    for sh in ["m", "re", "s", "ve", "d"]

        st = replace(st, "'$(titlecase(sh)) " => "'$sh ")

    end

    st

end
