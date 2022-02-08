function sum_1_absolute_and_0_count(ve, bi_)

    su1 = 0

    su0 = 0

    for id in 1:length(ve)

        if bi_[id] == 1

            nu = ve[id]

            if nu < 0

                nu = -nu

            end

            su1 += nu

        else

            su0 += 1

        end

    end

    return su1, su0

end
