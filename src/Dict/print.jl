function print(ke_va, n = -1; so = true)

    n_ke = length(keys(ke_va))

    n_va = length(unique(values(ke_va)))

    println(
        "$n_ke $(BioLab.String.count_noun(n_ke, "key")) and $n_va unique $(BioLab.String.count_noun(n_va, "value"))",
    )

    if n_ke == 0

        return

    end

    if so

        ke_va = sort(OrderedDict(ke_va))

    end

    if n == -1

        JSON_print(ke_va, 2)

    elseif 0 < n

        println("{")

        for (id, (ke, va)) in enumerate(ke_va)

            Base.print("  ")

            if id <= n

                println("$ke => $va")

            else

                println("...")

                break

            end

        end

        println("}")

    end

end
