module String

using Random: randstring

function is_bad(st)

    isempty(st) || contains(st, r"^[^0-9A-Za-z]+$")

end

function make(ar_...)

    randstring(ar_...)

end

function try_parse(st)

    try

        return convert(Int, parse(Float64, st))

    catch

    end

    try

        return parse(Float64, st)

    catch

    end

    st

end

function limit(st, n)

    n < lastindex(st) ? "$(view(st, 1:n))..." : st

end

function split_get(st, de, id)

    split(st, de; limit = id + 1)[id]

end

function count(n, st)

    n_ch = lastindex(st)

    if iszero(n) || isone(abs(n))

        pl = st

    elseif n_ch == 3 && view(st, 2:3) == "ex"

        pl = "$(st)es"

    elseif endswith(st, "ex")

        pl = "$(view(st, 1:(n_ch - 2)))ices"

    elseif endswith(st, "ry")

        pl = "$(view(st, 1:(n_ch - 2)))ries"

    elseif endswith(st, "o")

        pl = "$(view(st, 1:(n_ch - 1)))oes"

    else

        pl = "$(st)s"

    end

    "$n $pl"

end

end
