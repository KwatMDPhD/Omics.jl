function animate(he__, di; pe = 1)

    dw = joinpath(homedir(), "Downloads")

    pr = "spider.animate.temporary"

    rm.(OnePiece.path.select(dw, ke_ = [pr]))

    n_he_ = length(he__)

    if pe < 1

        pe = round(Int, pe * n_he_)

        println("Plotting per $pe / $n_he_")

    end

    for id in 1:n_he_

        if !(id == 1 || id % pe == 0 || id == n_he_)

            continue

        end

        if id == 1

            js = ""

        else

            js = joinpath(dw, "$pr.1.json")

        end

        display(plot(js = js, he_ = he__[id], ou = joinpath(di, "$pr.$id.html")))

        sleep(2)

    end

    for na in OnePiece.path.select(dw, ke_ = [pr], jo = false)

        mv(joinpath(dw, na), joinpath(di, na))

    end

    cd(di)

    for na in OnePiece.path.select(pwd(), ke_ = [pr], jo = false)

        mv(na, replace(na, "$pr." => ""))

    end

    run(`convert -delay 40 -loop 0 "*".png spider.gif`)

end
