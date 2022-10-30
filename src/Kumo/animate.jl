function animate(he__, di; pe = 1, js = "", st_ = [])

    #
    dw = joinpath(homedir(), "Downloads")

    pr = "Kumo.animate"

    for pa in OnePiece.Path.select(dw, ke_ = [pr])

        rm(pa)

    end

    #
    n = length(he__)

    if pe < 1

        pe = ceil(Int, pe * n)

    end

    println("Plotting every $pe of $n")

    #
    for id in 1:n

        #
        if !(id == 1 || id % pe == 0 || id == n)

            continue

        end

        #
        if js == "" && 1 < id

            js = joinpath(dw, "$pr.1.json")

        end

        display(plot(js = js, st_ = st_, he_ = he__[id], ht = joinpath(di, "$pr.$id.html")))

        pn = joinpath(dw, "$pr.$id.png")

        while !ispath(pn)

        end

    end

    #
    for na in OnePiece.Path.select(dw, false, ig_ = [r"\.download$"], ke_ = [pr])

        mv(joinpath(dw, na), joinpath(di, replace(na, "$pr." => "")), force = true)

    end

    #
    run(`convert -delay 32 -loop 0 $(sort(
        OnePiece.Path.select(di, ke_ = [r".png$"]),
        by = pa -> parse(Int, splitext(basename(pa))[1]),
       )) $(joinpath(di, "animate.gif"))`)

end
