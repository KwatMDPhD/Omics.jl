function heat(fi_, al_ve)

    ve_id = Dict(ve => id for (id, ve) in enumerate(string.(VERTEX_)))

    global HEAT_ = fill(0, length(ve_id))

    for (ve, fi) in fi_

        if !haskey(ve_id, ve)

            print("$ve =(alias)=> ")

            ve = al_ve[ve]

            println(ve)

        end

        HEAT_[ve_id[ve]] = fi

    end

    println("The total heat is $(sum(HEAT_)).")

end
