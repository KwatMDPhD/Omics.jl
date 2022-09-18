function animate(he__, di; pe = 1, js = "", st_ = [])

    dw = joinpath(homedir(), "Downloads")

    pr = "kumo.animate.temporary"

    rm.(OnePiece.path.select(dw, ke_ = [pr]))

    n_he_ = length(he__)

    if pe < 1

        pe = ceil(Int, pe * n_he_)

        println("Plotting every $pe of $n_he_")

    end

    for id in 1:n_he_

        if !(id == 1 || id % pe == 0 || id == n_he_)

            continue

        end

        if 1 < id && isempty(js)

            js = joinpath(dw, "$pr.1.json")

        end

        ht = joinpath(di, "$pr.$id.html")

        display(plot(js = js, st_ = st_, he_ = he__[id], ou = ht))

        while !ispath(joinpath(dw, "$pr.$id.png"))

        end

    end

    for na in OnePiece.path.select(dw, ke_ = [pr], ig_ = [r"\.download$"], jo = false)

        mv(joinpath(dw, na), joinpath(di, na), force = true)

    end

    for pa in OnePiece.path.select(di, ke_ = [pr])

        mv(pa, replace(pa, "$pr." => ""), force = true)

    end

    pn_ = sort(
        OnePiece.path.select(di, ke_ = [r".png$"]),
        by = pa -> parse(Int, splitext(basename(pa))[1]),
    )

    gi = joinpath(di, "animate.gif")

    run(`convert -delay 32 -loop 0 $pn_ $gi`)

end
