function heat(st_he; st_al_ = Dict(), ve_he = Dict(), pr = true)

    #
    st_hem = merge(st_he, ve_he)

    #
    he_ = fill(0.0, length(VE_))

    for (id, st) in enumerate(_stringify_vertex())

        #
        if haskey(st_hem, st)

            he_[id] = st_hem[st]

            #
        elseif haskey(st_al_, st)

            #
            hea_ = []

            for al in st_al_[st]

                if haskey(st_hem, al)

                    he = st_hem[al]

                    if pr

                        println("$st ==> $al ==> $he")

                    end

                    push!(hea_, he)

                end

            end

            #
            if !isempty(hea_)

                he = mean(hea_)

                println("$st ==> $he")

                he_[id] = he

            end

        end

    end

    #
    he_

end

function heat(st_, st_x_sa_x_he::Matrix; ke_ar...)

    hcat((heat(Dict(zip(st_, he_)); ke_ar...) for he_ in eachcol(st_x_sa_x_he))...)

end
