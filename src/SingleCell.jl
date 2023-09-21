module SingleCell

using ProgressMeter: @showprogress

using ..BioLab

function read(sa_di)

    fe_ = Vector{String}()

    ba_ = Vector{String}()

    idf_ = Vector{Int}()

    idb_ = Vector{Int}()

    co_ = Vector{Int}()

    sa_ = Vector{String}()

    n_ba = 0

    for (sa, di) in sa_di

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

        # TODO
        da = BioLab.DataFrame.read(joinpath(di, "matrix.mtx.gz"); header = 3)#, delim = ' ')

        n_fes = length(fes_)

        n_bas = length(bas_)

        co1, co2, co3 = (parse(Int, co) for co in names(da))

        if n_fes != co1

            error("Numbers of features differ. $n_fes != $co1 (matrix header).")

        end

        if n_bas != co2

            error("Numbers of barcodes differ. $n_bas != $co2 (matrix header).")

        end

        @info "$co1 x $co2 x $co3."

        if isempty(fe_)

            fe_ = fes_

        elseif fe_ != fes_

            error("Features differ.")

        end

        append!(ba_, ["$(sa)_$ba" for ba in bas_])

        append!(idf_, da[!, 1])

        append!(idb_, da[!, 2] .+ n_ba)

        append!(co_, da[!, 3])

        append!(sa_, fill(sa, n_bas))

        n_ba += n_bas

    end

    n_fe = length(fe_)

    @info "Combining $n_fe features and $n_ba barcodes"

    fe_x_ba_x_co = zeros(Int, n_fe, n_ba)

    @showprogress for (idf, idb, co) in zip(idf_, idb_, co_)

        fe_x_ba_x_co[idf, idb] = co

    end

    if !allunique(fe_)

        st = BioLab.Collection.count_sort_string(fe_, 2)

        @warn "Features have $(BioLab.String.count(length(split(st, '\n')), "duplicate")).\n$st"

        fe_, fe_x_ba_x_co = BioLab.Matrix.collapse(maximum, Int, fe_, fe_x_ba_x_co)

    end

    fe_, ba_, fe_x_ba_x_co, sa_

end

end
