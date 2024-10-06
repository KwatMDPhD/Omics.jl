module Strin

function _strip(st)

    replace(strip(st), r" +" => ' ')

end

function lower(st)

    _strip(replace(lowercase(st), r"[^._0-9a-z]" => '_'))

end

function title(st)

    _strip(
        join(
            if isuppercase(c1)
                c1
            else
                c2
            end for (c1, c2) in zip(
                st,
                replace(
                    titlecase(st),
                    '_' => ' ',
                    r"'m"i => "'m",
                    r"'re"i => "'re",
                    r"'s"i => "'s",
                    r"'ve"i => "'ve",
                    r"'d"i => "'d",
                    r"1st"i => "1st",
                    r"2nd"i => "2nd",
                    r"3rd"i => "3rd",
                    r"(?<=\d)th"i => "th",
                    r"(?<= )a(?= )"i => 'a',
                    r"(?<= )an(?= )"i => "an",
                    r"(?<= )the(?= )"i => "the",
                    r"(?<= )and(?= )"i => "and",
                    r"(?<= )but(?= )"i => "but",
                    r"(?<= )or(?= )"i => "or",
                    r"(?<= )nor(?= )"i => "nor",
                    r"(?<= )at(?= )"i => "at",
                    r"(?<= )by(?= )"i => "by",
                    r"(?<= )for(?= )"i => "for",
                    r"(?<= )from(?= )"i => "from",
                    r"(?<= )in(?= )"i => "in",
                    r"(?<= )into(?= )"i => "into",
                    r"(?<= )of(?= )"i => "of",
                    r"(?<= )off(?= )"i => "off",
                    r"(?<= )on(?= )"i => "on",
                    r"(?<= )onto(?= )"i => "onto",
                    r"(?<= )out(?= )"i => "out",
                    r"(?<= )over(?= )"i => "over",
                    r"(?<= )to(?= )"i => "to",
                    r"(?<= )up(?= )"i => "up",
                    r"(?<= )with(?= )"i => "with",
                    r"(?<= )as(?= )"i => "as",
                    r"(?<= )vs(?= )"i => "vs",
                ),
            )
        ),
    )

end

function count(uc, st)

    if !(iszero(uc) || isone(abs(uc)))

        st = if lastindex(st) == 3 && st[2:3] == "ex"

            "$(st)es"

        elseif endswith(st, "ex")

            "$(st[1:(end - 2)])ices"

        elseif endswith(st, "ry")

            "$(st[1:(end - 2)])ries"

        elseif endswith(st, 'o')

            "$(st[1:(end - 1)])oes"

        else

            "$(st)s"

        end

    end

    "$uc $st"

end

end
