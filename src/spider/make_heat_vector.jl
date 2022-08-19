function make_heat_vector(st_he, ve_al_)

    he_ = fill(0.0, length(VERTEX_))

    for (id, ve) in enumerate(string.(VERTEX_))

        if haskey(st_he, ve)

            he_[id] = st_he[ve]

        elseif haskey(ve_al_, ve)

            al_ = []

            for al in ve_al_[ve]

                if haskey(st_he, al)

                    println("$al =(alias)=> $ve")

                    push!(al_, st_he[al])

                end

            end

            if !isempty(al_)

                he_[id] = mean(al_)

            end

        end

    end

    he_

end
