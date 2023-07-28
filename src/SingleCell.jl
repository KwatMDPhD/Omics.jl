module SingleCell

using ProgressMeter: @showprogress

using BioLab

function read(sa_di)

    fe_ = Vector{String}()

    ba_ = Vector{String}()

    idf_ = Vector{Int}()

    idb_ = Vector{Int}()

    co_ = Vector{Int}()

    sa_ = Vector{String}()

    ids___ = Vector{UnitRange{Int}}()

    n_ba = 0

    for (sa, di) in sa_di

        @info "Reading $sa"

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

        da = BioLab.DataFrame.read(joinpath(di, "matrix.mtx.gz"); header = 3, delim = " ")

        n_fes = length(fes_)

        n_bas = length(bas_)

        co1, co2, co3 = (parse(Int, co) for co in names(da))

        if n_fes != co1

            error("There are $n_fes features, which is not $co1.")

        end

        if n_bas != co2

            error("There are $n_bas barcodes, which is not $co2.")

        end

        @info "$co1 x $co2 x $co3."

        if isempty(fe_)

            fe_ = fes_

        elseif fe_ != fes_

            error("Features mismatch.")

        end

        append!(ba_, string.("$sa.", bas_))

        append!(idf_, da[!, 1])

        append!(idb_, da[!, 2] .+ n_ba)

        append!(co_, da[!, 3])

        push!(sa_, sa)

        push!(ids___, (n_ba + 1):(n_ba + n_bas))

        n_ba += n_bas

    end

    n_fe = length(fe_)

    @info "Combining $n_fe features and $n_ba barcodes"

    fe_x_ba_x_co = zeros(Int, (n_fe, n_ba))

    @showprogress for (idf, idb, co) in zip(idf_, idb_, co_)

        fe_x_ba_x_co[idf, idb] = co

    end

    if !allunique(fe_)

        st = join(("$va $ke" for (ke, va) in BioLab.Collection.count_sort(fe_)), ". ")

        @warn "Features have duplicates.\n$st."

        fe_, fe_x_ba_x_co = BioLab.Matrix.collapse(maximum, Int, fe_, fe_x_ba_x_co)

    end

    fe_, ba_, fe_x_ba_x_co, sa_, ids___

end

function target(ta_re_, sa_)

    n_ta = length(ta_re_)

    ta_ = Vector{String}(undef, n_ta)

    ta_x_sa_x_nu = fill(NaN, (n_ta, length(sa_)))

    for (idt, (ta, re_)) in enumerate(ta_re_)

        ta_[idt] = ta

        for (nu, re) in zip((0, 1), re_)

            re2 = Regex(re)

            for (ids, sa) in enumerate(sa_)

                if contains(sa, re2)

                    ta_x_sa_x_nu[idt, ids] = nu

                end

            end

        end

    end

    ta_, ta_x_sa_x_nu

end

end
