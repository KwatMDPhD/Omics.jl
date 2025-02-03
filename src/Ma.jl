module Ma

function make(ta, ck_, cv)

    ke_va = Dict{String, String}()

    ke = Matrix(ta[!, ck_])

    va_ = ta[!, cv]

    for iv in eachindex(va_)

        va = va_[iv]

        if ismissing(va)

            continue

        end

        for ik in eachindex(ck_)

            ky = ke[iv, ik]

            if ismissing(ky)

                continue

            end

            for sp in eachsplit(ky, '|')

                ke_va[sp] = va

            end

        end

    end

    ke_va

end

function ge(ke_va, ke)

    haskey(ke_va, ke) ? ke_va[ke] : "_$ke"

end

function lo(va_)

    u1 = lastindex(va_)

    u2 = count(!startswith('_'), va_)

    @info "📛 $u2 / $u1 ($(u2 / u1 * 100)%)."

end

end
