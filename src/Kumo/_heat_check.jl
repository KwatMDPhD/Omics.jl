function _heat_check(he_, pr = true)

    no = norm(he_)

    if pr

        println("$(BioinformaticsCore.Number.format(no)) 🔥")

        for (he, ve) in zip(BioinformaticsCore.Vector.sort_like((he_, VE_), true)...)

            if he != 0.0

                println("$ve\t$(BioinformaticsCore.Number.format(he))")

            end

        end

    end

    no

end
