function _heat_check(he_; pr = true)

    no = norm(he_)

    if pr

        println("🔥 $(OnePiece.number.format(no))")

        for (_, (he, ve)) in enumerate(zip(OnePiece.vector.sort_like(he_, VERTEX_, re = true)...))

            if he != 0.0

                println("$ve\t$(OnePiece.number.format(he))")

            end

        end

    end

    no

end
