function error_bad(ve_)

    id_ba = Dict()

    for (id, ve) in enumerate(ve_)

        for an in ve

            if an isa String

                continue

            end

            if any(is(an) for is in [ismissing, isnothing, isnan, isinf])

                push!(get!(id_ba, id, []), an)

            end

        end

    end

    if !isempty(id_ba)

        OnePiece.dict.print(id_ba, n_pa = 8)

        error()

    end

end
