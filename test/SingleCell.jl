using BioLab

using ProgressMeter

# ---- #

ro = "/Users/kwat/craft/pro/ferreira"

# ---- #

al = joinpath(ro, "star")

na_sa = BioLab.Dict.read(joinpath(ro, "name_sample.json"))

# ---- #

println("💾 Reading")

fe_ = Vector{String}()

ba_ = Vector{String}()

idf_ = Vector{Int}()

idb_ = Vector{Int}()

co_ = Vector{Int}()

sa_ = Vector{String}()

ids___ = Vector{UnitRange{Int}}()

n_ba = 0

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

    push!(sa_, sa)

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

ta_ = ["TCR", "CAR", "Tef TCR", "Tef CAR", "Tre TCR", "Tre CAR"]

re___ = (
    (r"^.*\.No$", r"^.*\.TCR$"),
    (r"^.*\.No$", r"^.*\.CAR$"),
    (r"^.*\.Teff\.No$", r"^.*\.Teff\.TCR$"),
    (r"^.*\.Teff\.No$", r"^.*\.Teff\.CAR$"),
    (r"^.*\.Treg\.No$", r"^.*\.Treg\.TCR$"),
    (r"^.*\.Treg\.No$", r"^.*\.Treg\.CAR$"),
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

function keep(fe_x_ba_x_co, di, mis, mas, min, man)

    n = size(fe_x_ba_x_co, di)

    if di == 1

        ea = eachrow

    else

        ea = eachcol

    end

    su_ = Vector{Int}(undef, n)

    no_ = Vector{Int}(undef, n)

    @showprogress for (id, co_) in enumerate(ea(fe_x_ba_x_co))

        su_[id] = sum(co_)

        no_[id] = sum(co != 0 for co in co_)

    end

    title_text = "All $n"

    xaxiss = Dict("title" => Dict("text" => "Sum of Count"))

    xaxisn = Dict("title" => Dict("text" => "Number of Nonzero Count"))

    BioLab.Plot.plot_histogram(
        (su_,);
        layout = Dict("title" => Dict("text" => title_text), "xaxis" => xaxiss),
    )

    BioLab.Plot.plot_histogram(
        (no_,);
        layout = Dict("title" => Dict("text" => title_text), "xaxis" => xaxisn),
    )

    kes_ = [mis <= su <= mas for su in su_]

    n_ke = sum(kes_)

    BioLab.Plot.plot_histogram(
        (su_[kes_],);
        layout = Dict(
            "title" => Dict(
                "text" => "($mis to $mas) Selected $n_ke ($(BioLab.Number.format(n_ke / n * 100))%)",
            ),
            "xaxis" => xaxiss,
        ),
    )

    ken_ = [min <= no <= man for no in no_]

    n_ke = sum(ken_)

    BioLab.Plot.plot_histogram(
        (no_[ken_],);
        layout = Dict(
            "title" => Dict(
                "text" => "($min to $man) Selected $n_ke ($(BioLab.Number.format(n_ke / n * 100))%)",
            ),
            "xaxis" => xaxisn,
        ),
    )

    ke_ = [kes && ken for (kes, ken) in zip(kes_, ken_)]

    n_ke = sum(ke_)

    println("👍 Selected $n_ke ($(BioLab.Number.format(n_ke / n * 100))%)")

    ke_

end

# ---- #

println("🚮 Removing barcodes")

keb_ = keep(fe_x_ba_x_co, 2, 100, n_fe, n_fe * 0.05, n_fe)

# ---- #

println("🚮 Removing barcodes using features")

# ---- #

println("🚮 Removing features")

kef_ = keep(fe_x_ba_x_co, 1, 100, n_ba * 100, n_ba * 0.05, n_ba)

# ---- #

println("🩰 Normalizing")

# ---- #

bak_ = ba_[keb_]

BioLab.Table.write(
    joinpath(ro, "target_x_barcode_x_number.tsv"),
    BioLab.DataFrame.make("Target", ta_, bak_, ta_x_ba_x_nu[:, keb_]),
)

BioLab.Table.write(
    joinpath(ro, "feature_x_barcode_x_countp1log2.tsv"),
    BioLab.DataFrame.collapse(
        BioLab.DataFrame.make("Feature", fe_[kef_], bak_, log2.(fe_x_ba_x_co[kef_, keb_] .+ 1)),
    ),
)

# ---- #

target_x_barcode_x_number = BioLab.Table.read(joinpath(ro, "target_x_barcode_x_number.tsv"))

feature_x_barcode_x_count = BioLab.Table.read(joinpath(ro, "feature_x_barcode_x_countp1log2.tsv"))
