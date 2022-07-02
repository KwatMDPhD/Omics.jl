function print(di; n_pa = -1, sp = IN)

    println("$(length(keys(di))) keys and $(length(Set(values(di)))) unique values")

    if 0 < n_pa

        println("{")

        for (id, (ke, va)) in enumerate(di)

            if id <= n_pa

                println("$(" "^sp)$ke => $va")

            else

                println("...")

                break

            end

        end

        println("}")

    else

        JSON.print(di, sp)

    end

end
