module String

using Printf: @sprintf

using ..BioLab

function format(nu)

    if isequal(nu, -0.0)

        nu = 0.0

    end

    @sprintf "%.4g" nu

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

        "$(view(st, 1:n))..."

    else

        st

    end

end

function split_get(st, de, id)

    split(st, de; limit = id)[id]

end

function dice(st)

    split.(eachsplit(st, '\n'), '\t')

end

function count(n, st)

    if n <= 1

        return "$n $st"

    end

    if length(st) == 3 && view(st, 2:3) == "ex"

        return "$n $(st)es"

    end

    for (si, pl) in (("ex", "ices"), ("ry", "ries"), ("o", "oes"))

        if endswith(st, si)

            return "$n $(chop(st; tail=length(si)))$pl"

        end

    end

    "$n $(st)s"

end

end
