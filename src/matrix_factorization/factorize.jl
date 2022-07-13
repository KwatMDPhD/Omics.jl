function factorize(ma, ro_, co_, k_, ti, ou; al = :greedycd, it = 1000000, rp = 1)

    for k in k_

        re = nnmf(ma, k, alg = al, maxiter = it, replicates = rp, tol = 1.0e-4)

        h, w = re.H, re.W

        # Cluster h

        cl_ = []

        for co in eachcol(h)

            push!(cl_, findmax(co)[2])

        end

        ht = transpose(h)

        ht = hcat(ht, co_, cl_)

        gr = size(ht)[2]

        htc = sortslices(ht, dims = 1, by = x -> x[gr])

        coc_ = htc[:, gr - 1]

        htc = htc[:, setdiff(1:end, (gr, gr - 1))]

        hc = transpose(htc)

        # Cluster w

        cl_ = []

        for ro in eachrow(re.W)

            push!(cl_, findmax(ro)[2])

        end

        w = hcat(w, ro_, cl_)

        gr = size(w)[2]

        wc = sortslices(w, dims = 1, by = x -> x[gr])

        roc_ = wc[:, gr - 1]

        wc = wc[:, setdiff(1:end, (gr, gr - 1))]

        # Make heat map

        ti_fe =
            "title" => Dict(
                "text" => "$ti k = $k",
                "font" => Dict("family" => "Times New Roman", "size" => 32),
            )

        f(x) = 680 * (1 - exp(-0.3x))

        lah = Dict(ti_fe, "height" => f(k))

        law = Dict(ti_fe, "width" => f(k))

        for se in [
            [hc, string.("Factor ", 1:size(hc, 1)), coc_, lah, "h"],
            [wc, roc_, string.("Factor ", 1:size(wc, 2)), law, "w"],
        ]

            pa = joinpath(ou, "nmf", "k_$k")

            mkpath(pa)

            OnePiece.figure.plot_heat_map(
                se[1],
                se[2],
                se[3],
                layout = se[4],
                ou = joinpath(pa, "$(se[5]).html"),
            )

        end

    end

    println("Saved NMF results at $ou for k = $k_")

end
