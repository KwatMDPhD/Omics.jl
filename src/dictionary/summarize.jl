function summarize(di::Dict; n_pr::Int64 = 4)::Nothing

    println(
        length(keys(di)),
        " keys and ",
        length(Set(values(di))),
        " unique values:",
    )

    for (id, (ke, va)) in enumerate(di)

        if id <= n_pr

            println(ke, " => ", va)

        else

            println("...")

            break

        end

    end

    return

end

export summarize
