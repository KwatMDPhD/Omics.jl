function heat(fi_, al_ve)

    ve_id = Dict(ve => id for (id, ve) in enumerate(string.(VERTEX_)))

    fill!(resize!(HEAT_, length(ve_id)), 0.0)

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
