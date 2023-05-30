module DataFrame

using DataFrames: DataFrame as _DataFrame, insertcols!

using OrderedCollections: OrderedDict

using StatsBase: mean

using ..BioLab

function make(an___)

    BioLab.Array.error_size(an___)

    co_ = an___[1]

    _DataFrame([[an_[id] for an_ in an___[2:end]] for id in eachindex(co_)], co_)

end

function make(ro, ro_, co_, _x_co_x_an)

    insertcols!(_DataFrame(_x_co_x_an, co_), 1, ro => ro_)

end

function separate(row_x_column_x_anything)

    co_ = names(row_x_column_x_anything)

    id_ = 2:length(co_)

    co_[1],
    row_x_column_x_anything[:, 1]::Vector{String},
    co_[id_]::Vector{String},
    Matrix(row_x_column_x_anything[!, id_])

end

function print_column(row_x_column_x_anything)

    BioLab.Collection.print_unique(
        eachcol(row_x_column_x_anything),
        names(row_x_column_x_anything),
    )

end

function print_row(row_x_column_x_anything)

    BioLab.Collection.print_unique(eachrow(row_x_column_x_anything), row_x_column_x_anything[!, 1])

end

function collapse(row_x_column_x_anything; fu = mean, ty = Float64)

    println("Before $(size(row_x_column_x_anything)).")

    ro_id_ = OrderedDict{String, Vector{Int}}()

    ro, ro_, co_, ma = BioLab.DataFrame.separate(row_x_column_x_anything)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, Vector{Int}()), id)

    end

    n = length(ro_id_)

    if length(ro_) == n

        return row_x_column_x_anything

    end

    roc_ = Vector{String}(undef, n)

    mac = Matrix{ty}(undef, (n, length(co_)))

    for (id, (ro, id_)) in enumerate(ro_id_)

        roc_[id] = ro

        if length(id_) == 1

            nu_ = ma[id_[1], :]

        else

            nu_ = [fu(nu_) for nu_ in eachcol(ma[id_, :])]

        end

        mac[id, :] = nu_

    end

    collapsed_x_column_x_anything = BioLab.DataFrame.make(ro, roc_, co_, mac)

    println("After $(size(collapsed_x_column_x_anything)).")

    collapsed_x_column_x_anything

end

function map_to(row_x_column_x_anything, fu!, fr_, to; de = "", pr = false)

    row_x_from_x_anything = row_x_column_x_anything[!, fr_]

    to_ = row_x_column_x_anything[!, to]

    fr_to = Dict{typejoin((eltype(co) for co in eachcol(row_x_from_x_anything))...), eltype(to_)}()

    for (fr_, to) in zip(eachrow(row_x_from_x_anything), to_)

        if ismissing(to)

            continue

        end

        fu!(fr_to, to, to; pr)

        for fr in fr_

            if ismissing(fr)

                continue

            end

            if isempty(de)

                fr_ = [fr]

            else

                fr_ = split(fr, de)

            end

            for fr in fr_

                fu!(fr_to, fr, to; pr)

            end

        end

    end

    fr_to

end

end
