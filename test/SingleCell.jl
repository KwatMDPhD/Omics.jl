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

    sa = na_sa[na]

    println("👽 $sa")

    push!(sa_, sa)

    fes_ = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "features.tsv");
        header = false,
    )[
        !,
        2,
    ]

    n_fes = length(fes_)

    bas_ = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "barcodes.tsv");
        header = false,
    )[
        !,
        1,
    ]

    n_bas = length(bas_)

    da = BioLab.Table.read(
        joinpath(al, na, "Solo.out", "Gene", "filtered", "matrix.mtx");
        header = 3,
        delim = " ",
    )

    na1, na2, na3 = (parse(Int, na) for na in names(da))

    @assert n_fes == na1

    @assert n_bas == na2

    println("$na1 x $na2 x $na3")

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

n_fe = length(fe_)

@assert n_ba == length(ba_)

println("⬇️  There are $n_fe features.")

println("➡️  There are $n_ba barcodes.")

fe_x_ba_x_co = fill(0, (n_fe, n_ba))

@showprogress for (idf, idb, co) in zip(idf_, idb_, co_)

    fe_x_ba_x_co[idf, idb] = co

end

# ---- #

ta_ = (
    "T Ef - No vs TCR",
    "T Re - No vs TCR",
    "T Ef - No vs CAR",
    "T Re - No vs CAR",
    "No vs TCR",
    "No vs CAR",
)

re___ = (
    (r"^.*\.Teff\.No$", r"^.*\.Teff\.TCR$"),
    (r"^.*\.Treg\.No$", r"^.*\.Treg\.TCR$"),
    (r"^.*\.Teff\.No$", r"^.*\.Teff\.CAR$"),
    (r"^.*\.Treg\.No$", r"^.*\.Treg\.CAR$"),
    (r"^.*\.No$", r"^.*\.TCR$"),
    (r"^.*\.No$", r"^.*\.CAR$"),
)

ta_x_ba_x_nu = fill(NaN, (length(ta_), n_ba))

for (idt, re_) in enumerate(re___)

    for (nu, re) in zip((0, 1), re_)

        for (sa, ids_) in zip(sa_, ids___)

            if contains(sa, re)

                ta_x_ba_x_nu[idt, ids_] .= nu

            end

        end

    end

end

# ---- #

println("🚮 Removing barcodes")

su_ = Vector{Int}(undef, n_ba)

no_ = Vector{Int}(undef, n_ba)

@showprogress for (id, co_) in enumerate(eachcol(fe_x_ba_x_co))

    su_[id] = sum(co_)

    no_[id] = sum(co != 0 for co in co_)

end

title_text = "All $n_ba"

xaxiss = Dict("title" => Dict("text" => "Sum of Count"))

xaxisn = Dict("title" => Dict("text" => "Number of Nonzero"))

BioLab.Plot.plot_histogram(
    (su_,);
    layout = Dict("title" => Dict("text" => title_text), "xaxis" => xaxiss),
)

BioLab.Plot.plot_histogram(
    (no_,);
    layout = Dict("title" => Dict("text" => title_text), "xaxis" => xaxisn),
)

# ---- #

mi = n_fe * 0.1

ma = n_fe

kes_ = [mi < su < ma for su in su_]

n_ke = sum(kes_)

BioLab.Plot.plot_histogram(
    (su_[kes_],);
    layout = Dict(
        "title" => Dict(
            "text" => "($mi to $ma) Selected $n_ke ($(BioLab.Number.format(n_ke / n_ba * 100))%)",
        ),
        "xaxis" => xaxiss,
    ),
)

# ---- #

mi = n_fe * 0.02

ma = n_fe * 0.15

ken_ = [mi < no < ma for no in no_]

n_ke = sum(ken_)

BioLab.Plot.plot_histogram(
    (no_[ken_],);
    layout = Dict(
        "title" => Dict(
            "text" => "($mi to $ma) Selected $n_ke ($(BioLab.Number.format(n_ke / n_ba * 100))%)",
        ),
        "xaxis" => xaxisn,
    ),
)

# ---- #

keb_ = [kes && ken for (kes, ken) in zip(kes_, ken_)]

n_ke = sum(keb_)

println("👍 Selected $n_ke ($(BioLab.Number.format(n_ke / n_ba * 100))%)")

# ---- #

println("🚮 Removing barcodes using features")

# ---- #

println("🚮 Removing features")

su_ = Vector{Int}(undef, n_fe)

no_ = Vector{Int}(undef, n_fe)

@showprogress for (id, co_) in enumerate(eachrow(fe_x_ba_x_co))

    su_[id] = sum(co_)

    no_[id] = sum(co != 0 for co in co_)

end

title_text = "All $n_fe"

xaxiss = Dict("title" => Dict("text" => "Sum of Count"))

xaxisn = Dict("title" => Dict("text" => "Number of Nonzero"))

BioLab.Plot.plot_histogram(
    (su_,);
    layout = Dict("title" => Dict("text" => title_text), "xaxis" => xaxiss),
)

BioLab.Plot.plot_histogram(
    (no_,);
    layout = Dict("title" => Dict("text" => title_text), "xaxis" => xaxisn),
)

# ---- #

mi = n_ba * 0.1

ma = n_ba

kes_ = [mi < su < ma for su in su_]

n_ke = sum(kes_)

BioLab.Plot.plot_histogram(
    (su_[kes_],);
    layout = Dict(
        "title" => Dict(
            "text" => "($mi to $ma) Selected $n_ke ($(BioLab.Number.format(n_ke / n_fe * 100))%)",
        ),
        "xaxis" => xaxiss,
    ),
)

# ---- #

mi = n_ba * 0.1

ma = n_ba

ken_ = [mi < no < ma for no in no_]

n_ke = sum(ken_)

BioLab.Plot.plot_histogram(
    (no_[ken_],);
    layout = Dict(
        "title" => Dict(
            "text" => "($mi to $ma) Selected $n_ke ($(BioLab.Number.format(n_ke / n_fe * 100))%)",
        ),
        "xaxis" => xaxisn,
    ),
)

# ---- #

kef_ = [kes && ken for (kes, ken) in zip(kes_, ken_)]

n_ke = sum(kef_)

println("👍 Selected $n_ke ($(BioLab.Number.format(n_ke / n_fe * 100))%)")

# ---- #

println("🩰 Normalizing")

# ---- #

BioLab.Table.write(
    joinpath(ro, "target_x_barcode_x_number.tsv"),
    BioLab.DataFrame.make("Target", ta_, ba_[keb_], ta_x_ba_x_nu[:, keb_]),
)

BioLab.Table.write(
    joinpath(ro, "feature_x_barcode_x_count.tsv"),
    BioLab.DataFrame.make("Feature", fe_[kef_], ba_[keb_], fe_x_ba_x_co[kef_, keb_]),
)

# ---- #

target_x_barcode_x_number = BioLab.Table.read(joinpath(ro, "target_x_barcode_x_number.tsv"))

feature_x_barcode_x_count = BioLab.Table.read(joinpath(ro, "feature_x_barcode_x_count.tsv"))
