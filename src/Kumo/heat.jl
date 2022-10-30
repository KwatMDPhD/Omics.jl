function heat(st_, he_; ve_al_ = Dict(), ve_he = Dict(), pr = true)

    #
    st_he = merge(Dict(zip(st_, he_)), ve_he)

    #
    hev_ = fill(0.0, length(VE_))

    for (id, ve) in enumerate(_stringify_vertex())

        #
        if haskey(st_he, ve)

            hev_[id] = st_he[ve]

            #
        elseif haskey(ve_al_, ve)

            #
            hea_ = []

            for al in ve_al_[ve]

                if haskey(st_he, al)

                    hea = st_he[al]

                    if pr

                        println("$ve ==> $al ==> $hea")

                    end

                    push!(hea_, hea)

                end

            end

            #
            if !isempty(hea_)

                hea = mean(hea_)

                println("$ve ==> $hea")

                hev_[id] = hea

            end

        end

    end

    #
    hev_

end

function heat(st_, st_x_sa_x_he::Matrix; ke_ar...)

    hcat([heat(st_, he_; ke_ar...) for he_ in eachcol(st_x_sa_x_he)]...)

end
