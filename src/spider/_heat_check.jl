function _heat_check(he_)

    no = norm(he_)

    println("🔥 $(OnePiece.number.format(no))")

    for (_, (he, ve)) in enumerate(zip(OnePiece.vector.sort_like(he_, VERTEX_, re = true)...))

        if he == 0.0

            continue

        end

        println("$ve $(OnePiece.number.format(he))")

    end

    no

end
