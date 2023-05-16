using BioLab

using ProgressMeter

# ---- #

ro = "/Users/kwat/Desktop/ferreira"

# ---- #

al = joinpath(ro, "star")

na_sa = BioLab.Dict.read(joinpath(ro, "name_sample.json"))

# ---- #

println("💾 Reading")

sa_ = Vector{String}()

fe_ = Vector{String}()

ba_ = Vector{String}()

idf_ = Vector{Int}()

idb_ = Vector{Int}()

co_ = Vector{Int}()

ids___ = Vector{UnitRange{Int}}()

n_ba = 0

# TODO: Rename `list`.
for na in BioLab.Path.list(al)

    #

    sa = na_sa[na]

    println("👽 $sa")

    push!(sa_, sa)

    #

    fes_ = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "features.tsv");
        header = false,
    )[
        !,
        2,
    ]

    n_fes = length(fes_)

    #

    bas_ = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "barcodes.tsv");
        header = false,
    )[
        !,
        1,
    ]

    n_bas = length(bas_)

    #

    da = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "matrix.mtx");
        header = 3,
        delim = " ",
    )

    na1, na2, na3 = (parse(Int, na) for na in names(da))

    @assert na1 == n_fes

    @assert na2 == n_bas

    println("$na1 x $na2 x $na3")

    #

    if isempty(fe_)

        global fe_ = fes_

    else

        @assert fe_ == fes_

    end

    append!(ba_, ["$sa.$ba" for ba in bas_])

    append!(idf_, da[!, 1])

    append!(idb_, [n_ba + id for id in da[!, 2]])

    append!(co_, da[!, 3])

    push!(ids___, (n_ba + 1):(n_ba + n_bas))

    global n_ba += n_bas

end

# ---- #

un_ = unique(idf_)

fe2_ = fe_[un_]

n_fe2 = length(fe2_)

println("⬇️  There are $n_fe2 nonzero features.")

idf_idf2 = Dict(un => id for (id, un) in enumerate(un_))

# ---- #

@assert n_ba == length(ba_)

println("➡️  There are $n_ba barcodes.")

fe2_x_ba_x_co = fill(0, (n_fe2, n_ba))

@showprogress for (idf, idb, co) in zip(idf_, idb_, co_)

    fe2_x_ba_x_co[idf_idf2[idf], idb] = co

end

# ---- #

re___ = (
    (r"^.*\.Teff\.No$", r"^.*\.Teff\.TCR$"),
    (r"^.*\.Treg\.No$", r"^.*\.Treg\.CAR$"),
    (r"^.*\.No$", r"^.*\.TCR$"),
    (r"^.*\.No$", r"^.*\.CAR$"),
)

n_ta = length(re___)

ta_x_ba_x_nu = fill(NaN, n_ta, n_ba)

ta_ = Vector{String}(undef, n_ta)

for (idt, re_) in enumerate(re___)

    st_ = Vector{String}()

    for (nu, re) in zip((0, 1), re_)

        for (sa, ids_) in zip(sa_, ids___)

            if contains(sa, re)

                ta_x_ba_x_nu[idt, ids_] .= nu

            end

        end

        push!(st_, replace(BioLab.Path.clean(string(re)[2:end]), '_' => "", r"\." => ""))

    end

    ta_[idt] = join(st_, '.')

end

# ---- #

println("🚮 Removing barcodes")

cop_ = [sum(co_) / n_fe2 for co_ in eachcol(fe2_x_ba_x_co)]

yaxis = Dict("title" => Dict("text" => "N"))

xaxis = Dict("title" => Dict("text" => "Count per Feature"))

BioLab.Plot.plot_histogram(
    (cop_,);
    # [cop_[id_] for id_ in ids___];
    # name_ = sa_,
    layout = Dict("title" => "All $n_ba", "yaxis" => yaxis, "xaxis" => xaxis),
)

mi = 0.1

ma = 1.0

ke_ = [mi < cop < ma for cop in cop_]

n_ba2 = sum(ke_)

BioLab.Plot.plot_histogram(
    (cop_[ke_],);
    # [cop_[id_][ke_[id_]] for id_ in ids___];
    # name_ = sa_,
    layout = Dict(
        "title" => "($mi < CpF < $ma) Selected $n_ba2 ($(BioLab.Number.format(n_ba2 / n_ba * 100))%)",
        "yaxis" => yaxis,
        "xaxis" => xaxis,
    ),
)

ba2_ = ba_[ke_]

ta_x_ba2_x_nu = ta_x_ba_x_nu[:, ke_]

fe2_x_ba2_x_co = fe2_x_ba_x_co[:, ke_]

# ---- #

println("🚮 Removing barcodes using features")

# ---- #

println("🩰 Normalizing barcodes")

# ---- #

BioLab.Table.write(
    joinpath(ro, "target_x_barcode_x_number.tsv"),
    BioLab.DataFrame.make("Target", ta_, ba2_, ta_x_ba2_x_nu),
)

BioLab.Table.write(
    joinpath(ro, "feature_x_barcode_x_count.tsv"),
    BioLab.DataFrame.make("Feature", fe2_, ba2_, fe2_x_ba2_x_co),
)
