function print(di, n_pa = nothing)

    n_ke = length(keys(di))

    n_va = length(Set(values(di)))

    println(
        "$n_ke $(OnePiece.String.count_noun(n_ke, "key")) and $n_va unique $(OnePiece.String.count_noun(n_va, "value"))",
    )

    if isnothing(n_pa)

        JSON_print(di, 2)

    else

        println("{")

        for (id, (ke, va)) in enumerate(di)

            Base.print("  ")

            if id <= n_pa

                println("$ke => $va")

            else

                println("...")

                break

            end

        end

        println("}")

    end

end
