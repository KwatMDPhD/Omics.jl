function summarize(di::Dict; n_pr::Int64 = 4)::Nothing

    println(length(keys(di)), " keys and ", length(Set(values(di))), " unique values")

    for (id, (ke, va)) in enumerate(di)

        if id <= n_pr

            println(ke, " => ", va)

        else

            if n_pr != 0

                println("...")

            end

            break

        end

    end

    return nothing

end
