module String

function is_bad(st)

    isempty(st) || contains(st, r"^[^0-9A-Za-z]+$")

end

function clean(st)

    replace(st, r"[^._0-9A-Za-z]" => '_')

end

function split_get(st, de, id)

    split(st, de; limit = id + 1)[id]

end

function count(nc, st)

    if iszero(nc) || isone(abs(nc))

        "$nc $st"

    elseif lastindex(st) == 3 && st[2:3] == "ex"

        "$nc $(st)es"

    elseif endswith(st, "ex")

        "$nc $(st[1:(end - 2)])ices"

    elseif endswith(st, "ry")

        "$nc $(st[1:(end - 2)])ries"

    elseif endswith(st, 'o')

        "$nc $(st[1:(end - 1)])oes"

    else

        "$nc $(st)s"

    end

end

end
