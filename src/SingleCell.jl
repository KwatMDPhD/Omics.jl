module SingleCell

using ..BioLab

function read(sa_di)

    fe_ = nothing

    n_fe = 0

    sa_ = String[]

    ba_ = String[]

    idf_ = Int[]

    idb_ = Int[]

    n_ba = 0

    co_ = Int[]

    for (sy, di) in zip(keys(sa_di), sa_di)

        sa = string(sy)

        @info "Reading \"$sa\""

        saf_ =
            BioLab.DataFrame.read(joinpath(di, "features.tsv.gz"); header = false, select = [2])[
                !,
                1,
            ]

        sab_ =
            BioLab.DataFrame.read(joinpath(di, "barcodes.tsv.gz"); header = false, select = [1])[
                !,
                1,
            ]

        n_saf = lastindex(saf_)

        n_sab = lastindex(sab_)

        index_x_featurebarcodecount_x_it =
            BioLab.DataFrame.read(joinpath(di, "matrix.mtx.gz"); header = 3)

        co1, co2, co3 = names(index_x_featurebarcodecount_x_it)

        if n_saf != parse(Int, co1)

            error("Numbers of features differ. $n_saf != $co1.")

        end

        if n_sab != parse(Int, co2)

            error("Numbers of barcodes differ. $n_sab != $co2.")

        end

        @info "$co1 x $co2 x $co3."

        if isnothing(fe_)

            fe_ = saf_

            n_fe = n_saf

        elseif fe_ != saf_

            error("Features differ.")

        end

        append!(sa_, fill(sa, n_sab))

        append!(ba_, (ba -> "$(sa)_$ba").(sab_))

        append!(idf_, index_x_featurebarcodecount_x_it[!, 1])

        append!(idb_, n_ba .+ index_x_featurebarcodecount_x_it[!, 2])

        n_ba += n_sab

        append!(co_, index_x_featurebarcodecount_x_it[!, 3])

    end

    @info "Combining $n_fe features and $n_ba barcodes"

    fe_x_ba_x_co = zeros(Int, n_fe, n_ba)

    for (idf, idb, co) in zip(idf_, idb_, co_)

        fe_x_ba_x_co[idf, idb] = co

    end

    if !allunique(fe_)

        @warn begin

            st = BioLab.Collection.count_sort_string(fe_, 2)

            "Features have $(BioLab.String.count(count('\n', st), "duplicate")).\n$st"

        end

        fe_, fe_x_ba_x_co = BioLab.Matrix.collapse(maximum, Int, fe_, fe_x_ba_x_co)

    end

    fe_, ba_, fe_x_ba_x_co, sa_

end

end
