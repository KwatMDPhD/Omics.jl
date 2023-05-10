using BioLab

using ProgressMeter

# ---- #

ro = "/Users/kwat/Desktop/ferreira"

# ---- #

al = joinpath(ro, "star")

id_sa = BioLab.Dict.read(joinpath(ro, "id_sample.json"))

# ---- #

println("💾 Reading")

fe_ = Vector{String}()

ba_ = Vector{String}()

id1_ = Vector{Int}()

id2_ = Vector{Int}()

n_ = Vector{Int}()

# TODO: Rename `list`.
for na in BioLab.Path.list(al)

    sa = id_sa[na]

    println("👽 $sa")

    fes_ = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "features.tsv");
        header = false,
    )[
        !,
        2,
    ]

    if isempty(fe_)

        fe_ = fes_

    else

        @assert fe_ == fes_

    end

    bas_ = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "barcodes.tsv");
        header = false,
    )[
        !,
        1,
    ]

    n_ba = length(ba_)

    append!(ba_, ["$sa.$ba" for ba in bas_])

    da = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "matrix.mtx");
        header = 3,
        delim = " ",
    )

    na1, na2, na3 = (parse(Int, na) for na in names(da))

    @assert length(fes_) == na1

    @assert length(bas_) == na2

    println("$na1 x $na2 x $na3")

    append!(id1_, da[!, 1])

    append!(id2_, [n_ba + id for id in da[!, 2]])

    append!(n_, da[!, 3])

end

# ---- #

id1u_ = unique(id1_)

id1_id1ui = Dict(un => id for (id, un) in enumerate(id1u_))

feu_ = fe_[id1u_]

n_feu = length(feu_)

println("👍 Keeping $n_feu features with a nonzero")

# ---- #

n_ba = length(ba_)

println("👍 Keeping all $n_ba barcodes")

fe_x_ba_x_n = fill(0, (n_feu, n_ba))

@showprogress for (id1, id2, n) in zip(id1_, id2_, n_)

    fe_x_ba_x_n[id1_id1ui[id1], id2] = n

end

# ---- #

su_ = [sum(n_) for n_ in eachcol(fe_x_ba_x_n)]

BioLab.Plot.plot_histogram((su_,))

# ---- #
