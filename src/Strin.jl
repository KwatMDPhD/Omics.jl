module Strin

using Dates: @dateformat_str, Date

using Printf: @sprintf

function _strip(st)

    replace(strip(st), r" +" => ' ')

end

function lower(st)

    _strip(replace(lowercase(st), r"[^._0-9a-z]" => '_'))

end

function title(st)

    _strip(
        join(
            isuppercase(or) ? or : re for (or, re) in zip(
                st,
                replace(
                    titlecase(st),
                    '_' => ' ',
                    r"'M" => "'m",
                    r"'Re" => "'re",
                    r"'S" => "'s",
                    r"'Ve" => "'ve",
                    r"'D" => "'d",
                    r"1St" => "1st",
                    r"2Nd" => "2nd",
                    r"3Rd" => "3rd",
                    r"(?<=\d)Th" => "th",
                    r"(?<= )a(?= )"i => 'a',
                    r"(?<= )an(?= )"i => "an",
                    r"(?<= )and(?= )"i => "and",
                    r"(?<= )as(?= )"i => "as",
                    r"(?<= )at(?= )"i => "at",
                    r"(?<= )but(?= )"i => "but",
                    r"(?<= )by(?= )"i => "by",
                    r"(?<= )for(?= )"i => "for",
                    r"(?<= )from(?= )"i => "from",
                    r"(?<= )in(?= )"i => "in",
                    r"(?<= )into(?= )"i => "into",
                    r"(?<= )nor(?= )"i => "nor",
                    r"(?<= )of(?= )"i => "of",
                    r"(?<= )off(?= )"i => "off",
                    r"(?<= )on(?= )"i => "on",
                    r"(?<= )onto(?= )"i => "onto",
                    r"(?<= )or(?= )"i => "or",
                    r"(?<= )out(?= )"i => "out",
                    r"(?<= )over(?= )"i => "over",
                    r"(?<= )the(?= )"i => "the",
                    r"(?<= )to(?= )"i => "to",
                    r"(?<= )up(?= )"i => "up",
                    r"(?<= )vs(?= )"i => "vs",
                    r"(?<= )with(?= )"i => "with",
                ),
            )
        ),
    )

end

function coun(uc, st)

    if 1 < abs(uc)

        st = if lastindex(st) == 3 && endswith(st, "ex")

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

function shorten(nu)

    @sprintf "%.2g" nu

end

function date(st)

    Date(st, dateformat"yyyy mm dd")

end

end
