function heat(st_he, ve_al_)

    empty!(HEAT_)

    for ve in string.(VERTEX_)

        if haskey(st_he, ve)

            he = st_he[ve]

        elseif haskey(ve_al_, ve)

            he_ = []

            for al in ve_al_[ve]

                if haskey(st_he, al)

                    println("$al =(alias)=> $ve")

                    push!(he_, st_he[al])

                end

            end

            if isempty(he_)

                println("$ve and its aliases are missing.")

                he = 0.0

            else

                he = sum(he_)

            end

        else

            println("$ve is missing.")

            he = 0.0

        end

        push!(HEAT_, he)

    end

end
