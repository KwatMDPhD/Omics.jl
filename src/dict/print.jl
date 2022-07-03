function print(di; n_pa = -1, sp = IN)

    println("$(length(keys(di))) keys and $(length(Set(values(di)))) unique values")

    if n_pa == -1

        JSON.print(di, sp)

    else

        println("{")

        sp = " "^sp

        for (id, (ke, va)) in enumerate(di)

            if id <= n_pa

                println("$sp$ke => $va")

            else

                println("$sp...")

                break

            end

        end

        println("}")

    end

end
