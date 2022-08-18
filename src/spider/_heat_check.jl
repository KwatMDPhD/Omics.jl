function _heat_check()

    println("🔥")

    no = norm(HEAT_)

    println("Norm $(OnePiece.number.format(no))")

    println("Sum $(OnePiece.number.format(sum(HEAT_)))")

    for (_, (he, ve)) in enumerate(zip(OnePiece.vector.sort_like(HEAT_, VERTEX_, re = true)...))

        if he == 0.0

            continue

        end

        println("$ve $(OnePiece.number.format(he))")

    end

    no

end
