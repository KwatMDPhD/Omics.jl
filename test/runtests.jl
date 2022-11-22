sr = joinpath(dirname(@__DIR__), "src")

sr_ = [na for na in readdir(sr)]

te_ = (splitext(na)[1] for na in readdir() if endswith(na, ".ipynb"))

symdiff(sr_, te_)

using BioinformaticsCore

BioinformaticsCore.TE

for nb in BioinformaticsCore.Path.select(".", false, ig_ = (r"^runtests",), ke_ = (r".ipynb$",))

    na = splitext(nb)[1]

    println("="^99)

    println(na)

    ma_ = Set()

    for ce in BioinformaticsCore.Dict.read(nb)["cells"]

        if ce["cell_type"] != "markdown"

            continue

        end

        for li in ce["source"]

            push!(ma_, BioinformaticsCore.String.split_and_get(rstrip(li, '\n'), " ", 2))

        end

    end

    for jl in BioinformaticsCore.Path.select(
        joinpath(dirname(@__DIR__), "src", na),
        false,
        ig_ = (r"^_.jl$",),
        ke_ = (r".jl$",),
    )

        naj = splitext(jl)[1]

        if naj in ma_

            pop!(ma_, naj)

        else

            println("  < $naj")

        end

    end

    if !isempty(ma_)

        println("  > $(join(ma_, "\n  >"))")

    end

end

BioinformaticsCore.IPYNB.run(@__DIR__, ["$pr.ipynb" for pr in ("runtests", "Kumo")])
