function heat(st_he_, ve_al_)

    n_sa_ = unique(length.(values(st_he_)))

    if length(n_sa_) != 1

        error()

    end

    n_sa = n_sa_[1]

    ve_x_sa_x_he = fill(0.0, length(VERTEX_), n_sa)

    for (id, ve) in enumerate(string.(VERTEX_))

        if haskey(st_he_, ve)

            ve_x_sa_x_he[id, :] = st_he_[ve]

        elseif haskey(ve_al_, ve)

            al_ = []

            for al in ve_al_[ve]

                if haskey(st_he_, al)

                    println("$al =(alias)=> $ve")

                    push!(al_, st_he_[al])

                end

            end

            if !isempty(al_)

                ve_x_sa_x_he[id, :] = mean(al_)

            end

        end

    end

    ve_x_sa_x_he

end

function heat(st_he::Dict{<:AbstractString, <:Real}, ve_al_)

    heat(Dict(st => [he] for (st, he) in st_he), ve_al_)[:, 1]

end
