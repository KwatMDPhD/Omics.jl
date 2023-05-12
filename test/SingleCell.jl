using BioLab

using ProgressMeter

# ---- #

ro = "/Users/kwat/Desktop/ferreira"

# ---- #

al = joinpath(ro, "star")

na_sa = BioLab.Dict.read(joinpath(ro, "name_sample.json"))

# ---- #

println("💾 Reading")

fe_ = Vector{String}()

ba_ = Vector{String}()

n_ba = 0

idf_ = Vector{Int}()

idb_ = Vector{Int}()

co_ = Vector{Int}()

# TODO: Rename `list`.
for na in BioLab.Path.list(al)

    sa = na_sa[na]

    println("👽 $sa")

    fes_ = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "features.tsv");
        header = false,
    )[
        !,
        2,
    ]

    if isempty(fe_)

        global fe_ = fes_

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

    append!(ba_, ["$sa.$ba" for ba in bas_])

    da = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "matrix.mtx");
        header = 3,
        delim = " ",
    )

    n_fes, n_bas, n_cos = (parse(Int, na) for na in names(da))

    @assert length(fes_) == n_fes

    @assert length(bas_) == n_bas

    println("$n_fes x $n_bas x $n_cos")

    append!(idf_, da[!, 1])

    append!(idb_, [n_ba + id for id in da[!, 2]])

    global n_ba += n_bas

    append!(co_, da[!, 3])

end

# ---- #

un_ = unique(idf_)

idf_idf2 = Dict(un => id for (id, un) in enumerate(un_))

fe_ = fe_[un_]

n_fe = length(fe_)

println("⬇️  There are $n_fe nonzero features.")

# ---- #

n_ba = length(ba_)

println("➡️  There are $n_ba barcodes.")

fe_x_ba_x_co = fill(0, (n_fe, n_ba))

@showprogress for (idf, idb, co) in zip(idf_, idb_, co_)

    fe_x_ba_x_co[idf_idf2[idf], idb] = co

end

# ---- #

println("🚮 Removing barcodes")

cof_ = [sum(co_) / n_fe for co_ in eachcol(fe_x_ba_x_co)]

xaxis = Dict("title" => Dict("text" => "Count per Feature"))

BioLab.Plot.plot_histogram((cof_,); layout = Dict("title" => "All", "xaxis" => xaxis))

mi = 0.1

ma = 1.0

ke_ = [mi <= cof <= ma for cof in cof_]

BioLab.Plot.plot_histogram(
    (cof_[ke_],);
    layout = Dict("title" => "$(sum(ke_)) Selected ($mi <= CpF <= $ma)", "xaxis" => xaxis),
)

# ---- #

println("🚮 Removing barcodes using features")

# ---- #

println("🩰 Normalizing barcodes")

# ---- #
