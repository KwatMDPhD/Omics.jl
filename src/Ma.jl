module Ma

function make(an, c1_, c2)

    di = Dict{String, String}()

    ke = Matrix(an[!, c1_])

    va_ = an[!, c2]

    for i1 in eachindex(va_)

        va = va_[i1]

        if ismissing(va)

            continue

        end

        for i2 in eachindex(c1_)

            ey = ke[i1, i2]

            if ismissing(ey)

                continue

            end

            # TODO: Generalize.
            for st in eachsplit(ey, '|')

                di[st] = va

            end

        end

    end

    di

end

function ge(di, ke)

    haskey(di, ke) ? di[ke] : "_$ke"

end

function lo(va_)

    n1 = lastindex(va_)

    n2 = count(!startswith('_'), va_)

    @info "📛 $n2 / $n1 ($(n2 / n1 * 100)%)."

end

end
