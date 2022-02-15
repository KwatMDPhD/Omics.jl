function summarize(di; n_pr = 3)

    println(length(keys(di)), " keys and ", length(Set(values(di))), " unique values")

    for (id, (ke, va)) in enumerate(di)

        if id <= n_pr

            println(ke, " => ", va)

        else

            println("...")

            break

        end

    end

end
