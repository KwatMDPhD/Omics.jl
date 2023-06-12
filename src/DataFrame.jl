module DataFrame

using DataFrames: DataFrame as _DataFrame, insertcols!

using OrderedCollections: OrderedDict

using StatsBase: mean

using ..BioLab

function make(an___)

    BioLab.Array.error_size_difference(an___)

    co_ = an___[1]

    _DataFrame([[an_[id] for an_ in an___[2:end]] for id in eachindex(co_)], co_)

end

function make(st::AbstractString)

    make([split(li, '\t') for li in split(st, "\n")])

end

function make(ron, con_, ro_an__)

    ro_ = sort!(collect(union(map(keys, ro_an__)...)))

    an__ = [Vector{Any}(undef, 1 + length(con_)) for _ in 1:(1 + length(ro_))]

    id = 1

    an__[id][1] = ron

    an__[id][2:end] = con_

    for (id, ro) in enumerate(ro_)

        id = 1 + id

        an__[id][1] = ro

        an__[id][2:end] = [get(ro_an, ro, missing) for ro_an in ro_an__]

    end

    make(an__)

end

function make(ro, ro_, co_, _x_co_x_an)

    insertcols!(_DataFrame(_x_co_x_an, co_), 1, ro => ro_)

end

function separate(row_x_column_x_anything)

    co_ = names(row_x_column_x_anything)

    id_ = 2:length(co_)

    co_[1],
    row_x_column_x_anything[:, 1]::Vector{<:AbstractString},
    co_[id_]::Vector{String},
    Matrix(row_x_column_x_anything[!, id_])

end

function collapse(row_x_column_x_anything; fu = mean, ty = Float64)

    @info "Size before collapsing is $(size(row_x_column_x_anything))."

    ro_id_ = OrderedDict{String, Vector{Int}}()

    ro, ro_, co_, ma = BioLab.DataFrame.separate(row_x_column_x_anything)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, Vector{Int}()), id)

    end

    n = length(ro_id_)

    if length(ro_) == n

        @warn "There are no rows to collapse."

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

    collapsed_x_column_x_anything = make(ro, roc_, co_, mac)

    @info "Size after is $(size(collapsed_x_column_x_anything))."

    collapsed_x_column_x_anything

end

function map_to(row_x_column_x_anything, fu!, fr_, to; de = "")

    to_ = row_x_column_x_anything[!, to]

    fr_to = Dict{
        typejoin((eltype(skipmissing(co)) for co in eachcol(row_x_column_x_anything))...),
        eltype(skipmissing(to_)),
    }()

    for (fr_, to) in zip(eachrow(row_x_column_x_anything[!, fr_]), to_)

        if BioLab.Bad.is_bad(to)

            continue

        end

        fu!(fr_to, to, to)

        for fr in fr_

            if BioLab.Bad.is_bad(fr)

                continue

            end

            if isempty(de)

                fr_ = [fr]

            else

                fr_ = split(fr, de)

            end

            for fr in fr_

                fu!(fr_to, fr, to)

            end

        end

    end

    fr_to

end

end
