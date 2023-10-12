module String

function is_bad(st)

    isempty(st) || contains(st, r"^[^0-9A-Za-z]+$")

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

    if n < length(st)

        "$(st[1:n])..."

    else

        st

    end

end

function split_get(st, de, id)

    split(st, de; limit = id + 1)[id]

end

function count(n, st)

    if n < 0

        error("$n is negative.")

    elseif n <= 1

        return "$n $st"

    end

    # TODO: Benchmark.
    if length(st) == 3 && view(st, 2:3) == "ex"

        return "$n $(st)es"

    end

    for (si, n_le, pl) in (("ex", 2, "ices"), ("ry", 2, "ries"), ("o", 1, "oes"))

        if endswith(st, si)

            return "$n $(st[1:(end - n_le)])$pl"

        end

    end

    "$n $(st)s"

end

end
