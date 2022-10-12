function print(da; n_ro = 3, n_co = 3)

    si1, si2 = size(da)

    println("Printing $si1 x $si2")

    if si1 == 0

        return

    end

    if si1 <= n_ro

        id1__ = [1:si1]

    else

        id1__ = [1:n_ro, (si1 - n_ro + 1):si1]

    end

    if si2 <= n_co

        id2__ = [1:si2]

    else

        id2__ = [1:n_co, (si2 - n_co + 1):si2]

    end

    for id1_ in id1__, id2_ in id2__

        println("$id1_ x $id2_")

        println(da[id1_, id2_])

    end

end
