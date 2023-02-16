function title(st)

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

    for sh in ("m", "re", "s", "ve", "d")

        ti = replace(ti, "'$(titlecase(sh)) " => "'$sh ")

    end

    return strip(ti)

end
