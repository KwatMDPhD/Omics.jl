function _heat_check()

    println("Norm = $(norm(HEAT_))")

    println("Total = $(round(sum(HEAT_), sigdigits = 2))")

    for (_, (he, ve)) in enumerate(zip(OnePiece.vector.sort_like(HEAT_, VERTEX_, re = true)...))

        if he == 0.0

            continue

        end

        println("$ve = $(he)")

    end

end
