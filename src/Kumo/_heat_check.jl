function _heat_check(he_, pr = true)

    no = norm(he_)

    if pr

        println("$(BioLab.Number.format(no)) 🔥")

        for (he, ve) in zip(BioLab.Vector.sort_like((he_, VE_), true)...)

            if he != 0.0

                println("$ve\t$(BioLab.Number.format(he))")

            end

        end

    end

    no

end
