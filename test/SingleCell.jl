using BioLab

using ProgressMeter

# ---- #

di = "/Users/kwat/Desktop/ferreira_treg"

# ---- #

dis = joinpath(di, "star")

id_sa = BioLab.Dict.read(joinpath(di, "id_sample.json"))

# ---- #

id1_ = Vector{Int}()

id2_ = Vector{Int}()

n_ = Vector{Int}()

fe_ = Vector{String}()

ba_ = Vector{String}()

# TODO: Rename `list`.
for na in BioLab.Path.list(dis)

    sa = id_sa[na]

    BioLab.print_header(sa)

    #

    da = BioLab.Table.read(
        joinpath(dis, na, "Solo.out", "Gene", "filtered", "matrix.mtx");
        header = 3,
        delim = " ",
    )

    na1, na2, na3 = (parse(Int, na) for na in names(da))

    #

    append!(id1_, da[!, 1])

    n_ba = length(ba_)

    append!(id2_, [n_ba + id for id in da[!, 2]])

    append!(n_, da[!, 3])

    #

    fes_ = BioLab.Table.read(
        joinpath(dis, na, "Solo.out", "Gene", "filtered", "features.tsv");
        header = false,
    )[
        !,
        2,
    ]

    @assert na1 == length(fes_)

    if isempty(fe_)

        fe_ = fes_

    else

        @assert fe_ == fes_

    end

    #

    bas_ = BioLab.Table.read(
        joinpath(dis, na, "Solo.out", "Gene", "filtered", "barcodes.tsv");
        header = false,
    )[
        !,
        1,
    ]

    @assert na2 == length(bas_)

    append!(ba_, ["$sa.$ba" for ba in bas_])

    #

    println(na3)

end

# ---- #

n_fe = length(fe_)

n_ba = length(ba_)

fe_x_ba_x_n = fill(0, (n_fe, n_ba))

@showprogress for (id1, id2, n) in zip(id1_, id2_, n_)

    fe_x_ba_x_n[id1, id2] = n

end


# ---- #

BioLab.Table.write(
    joinpath(di, "feature_x_barcode_x_n.tsv"),
    BioLab.DataFrame.make("Gene", fe_, ba_, fe_x_ba_x_n),
)

# ---- #

da = BioLab.Table.read(joinpath(di, "feature_x_barcode_x_n.tsv"))
