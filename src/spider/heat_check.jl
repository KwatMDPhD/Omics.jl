function heat_check()

    println("The total heat is $(sum(HEAT_)).")

    for (id, (he, ve)) in enumerate(zip(OnePiece.vector.sort_like(HEAT_, VERTEX_, re = true)...))

        if he == 0.0

            continue

        end

        println("$ve = $he")

    end

end
