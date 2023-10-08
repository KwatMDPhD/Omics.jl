module SingleCell

using ..BioLab

function read(sa_di)

    fe_ = nothing

    n_fe = 0

    sa_ = Vector{String}()

    ba_ = Vector{String}()

    idf_ = Vector{Int}()

    n_ba = 0

    idb_ = Vector{Int}()

    co_ = Vector{Int}()

    for (sa, di) in zip(string.(keys(sa_di)), sa_di)

        @info "Reading \"$sa\""

        fes_ =
            BioLab.DataFrame.read(joinpath(di, "features.tsv.gz"); header = false, select = [2])[
                !,
                1,
            ]

        bas_ =
            BioLab.DataFrame.read(joinpath(di, "barcodes.tsv.gz"); header = false, select = [1])[
                !,
                1,
            ]

        index_x_featurebarcodecount_x_it =
            BioLab.DataFrame.read(joinpath(di, "matrix.mtx.gz"); header = 3)#, delim = ' ')

        n_fes = length(fes_)

        n_bas = length(bas_)

        co1, co2, co3 = (parse(Int, co) for co in names(index_x_featurebarcodecount_x_it))

        if n_fes != co1

            error("Numbers of features differ. $n_fes != $co1 (matrix header).")

        end

        if n_bas != co2

            error("Numbers of barcodes differ. $n_bas != $co2 (matrix header).")

        end

        @info "$co1 x $co2 x $co3."

        if isnothing(fe_)

            fe_ = fes_

            n_fe = n_fes

        elseif fe_ != fes_

            error("Features differ.")

        end

        append!(sa_, fill(sa, n_bas))

        append!(ba_, ["$(sa)_$ba" for ba in bas_])

        append!(idf_, index_x_featurebarcodecount_x_it[!, 1])

        append!(idb_, n_ba .+ index_x_featurebarcodecount_x_it[!, 2])

        n_ba += n_bas

        append!(co_, index_x_featurebarcodecount_x_it[!, 3])

    end

    @info "Combining $n_fe features and $n_ba barcodes"

    fe_x_ba_x_co = zeros(Int, n_fe, n_ba)

    for (idf, idb, co) in zip(idf_, idb_, co_)

        fe_x_ba_x_co[idf, idb] = co

    end

    if !allunique(fe_)

        st = BioLab.Collection.count_sort_string(fe_, 2)

        @warn "Features have $(BioLab.String.count(count('\n', st) + 1, "duplicate")).\n$st"

        fe_, fe_x_ba_x_co = BioLab.Matrix.collapse(maximum, Int, fe_, fe_x_ba_x_co)

    end

    fe_, ba_, fe_x_ba_x_co, sa_

end

end
