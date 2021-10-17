function summarize(di::Dict; n_pr::Int64 = 4)::Nothing

    println(
        length(keys(di)),
        " keys and ",
        length(Set(values(di))),
        " unique values:",
    )

    for (id, (ke, va)) in enumerate(di)

        println(ke, " => ", va)

        if n_pr < id

            println("...")

            break

        end

    end

    return

end

export summarize
