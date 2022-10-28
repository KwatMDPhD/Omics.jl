function _heat_check(he_, pr = true)

    no = norm(he_)

    if pr

        println("🔥 $(OnePiece.Number.format(no))")

        for (he, ve) in zip(OnePiece.vector.sort_like([he_, VE_], re = true)...)

            if he != 0.0

                println("$ve\t$(OnePiece.Number.format(he))")

            end

        end

    end

    no

end
