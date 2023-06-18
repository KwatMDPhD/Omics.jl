module SingleCell

using ProgressMeter

using ..BioLab

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

        @info "Reading $sa => $di"

        # TODO: Read only the column.
        fes_ = BioLab.Table.read(joinpath(di, "features.tsv.gz"); header = false)[!, 2]

        # TODO: Read only the column.
        bas_ = BioLab.Table.read(joinpath(di, "barcodes.tsv.gz"); header = false)[!, 1]

        da = BioLab.Table.read(joinpath(di, "matrix.mtx.gz"); header = 3, delim = " ")

        n_fes = length(fes_)

        n_bas = length(bas_)

        na1, na2, na3 = (parse(Int, na) for na in names(da))

        @assert n_fes == na1

        @assert n_bas == na2

        @info "$na1 x $na2 x $na3."

        if isempty(fe_)

            fe_ = fes_

        else

            @assert fe_ == fes_

        end

        append!(ba_, ["$sa.$ba" for ba in bas_])

        append!(idf_, da[!, 1])

        append!(idb_, [n_ba + id for id in da[!, 2]])

        append!(co_, da[!, 3])

        push!(sa_, sa)

        push!(ids___, (n_ba + 1):(n_ba + n_bas))

        n_ba += n_bas

    end

    n_fe = length(fe_)

    @assert n_ba == length(ba_)

    @info "Combining $n_fe features and $n_ba barcodes"

    fe_x_ba_x_co = fill(0, (n_fe, n_ba))

    @showprogress for (idf, idb, co) in zip(idf_, idb_, co_)

        fe_x_ba_x_co[idf, idb] = co

    end

    fe_, ba_, fe_x_ba_x_co, sa_, ids___

end

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

        no_[id] = sum(!iszero, co_)

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
                "text" => "($mis to $mas) Selected $n_ke ($(BioLab.String.format(n_ke / n * 100))%)",
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
                "text" => "($min to $man) Selected $n_ke ($(BioLab.String.format(n_ke / n * 100))%)",
            ),
            "xaxis" => xaxisn,
        ),
    )

    ke_ = [kes && ken for (kes, ken) in zip(kes_, ken_)]

    n_ke = sum(ke_)

    @info "Selected $n_ke ($(BioLab.String.format(n_ke / n * 100))%)."

    # TODO: Keep based on some features or barcodes.

    ke_

end

end
