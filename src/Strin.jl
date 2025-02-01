module Strin

using Dates: @dateformat_str, Date

function is_bad(st)

    isempty(st) || contains(st, r"^[^0-9A-Za-z]+$")

end

function slash(st)

    replace(st, '/' => '_')

end

function lower(st)

    replace(lowercase(st), r"[^._0-9a-z]" => '_')

end

function title(st)

    join(
        isuppercase(c1) ? c1 : c2 for (c1, c2) in zip(
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
    )

end

function stri(st)

    replace(strip(st), r" +" => ' ')

end

function limit(st, uc)

    lastindex(st) <= uc ? st : "$(st[1:uc])..."

end

function ge(st, id, de = ' ')

    split(st, de; limit = id + 1)[id]

end

function get_1(st, de = ' ')

    ge(st, 1, de)

end

function get_end(st, de = ' ')

    rsplit(st, de; limit = 2)[2]

end

function trim_1(st, de = ' ')

    split(st, de; limit = 2)[2]

end

function trim_end(st, de = ' ')

    rsplit(st, de; limit = 2)[1]

end

function coun(us, st)

    if 1 < abs(us)

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

    "$us $st"

end

function chain(st_)

    join(st_, " · ")

end

function date(st)

    Date(st, dateformat"yyyy mm dd")

end

end
