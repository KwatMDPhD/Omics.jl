function heat(st_, he_; ve_al_ = nothing, ve_he = Dict(), pr = true)

    st_he = merge(Dict(zip(st_, he_)), ve_he)

    hev_ = fill(0.0, length(VERTEX_))

    for (id, ve) in enumerate(string.(VERTEX_))

        if haskey(st_he, ve)

            hev_[id] = st_he[ve]

        elseif !isnothing(ve_al_) && haskey(ve_al_, ve)

            al_ = []

            for al in ve_al_[ve]

                if haskey(st_he, al)

                    if pr

                        println("$al =(alias)=> $ve")

                    end

                    push!(al_, st_he[al])

                end

            end

            if !isempty(al_)

                hev_[id] = mean(al_)

            end

        end

    end

    hev_

end

function heat(st_, st_x_sa_x_he::Matrix; ke_ar...)

    hcat([heat(st_, co; ke_ar...) for co in eachcol(st_x_sa_x_he)]...)

end