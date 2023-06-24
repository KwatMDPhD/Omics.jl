module DataFrame

using DataFrames: DataFrame as _DataFrame, insertcols!

using OrderedCollections: OrderedDict

using StatsBase: mean

using ..BioLab

function make(an___)

    BioLab.Array.error_size_difference(an___)

    co_ = an___[1]

    # TODO: Use BioLab.Matrix.make(an___[2:end])
    _DataFrame([[an_[id] for an_ in an___[2:end]] for id in eachindex(co_)], co_)

end

function make(st::AbstractString)

    make([split(li, '\t') for li in split(st, '\n')])

end

function make(nar, co_, ro_an__)

    ro_ = sort!(collect(union(map(keys, ro_an__)...)))

    an__ = [Vector{Any}(undef, 1 + length(co_)) for _ in 1:(1 + length(ro_))]

    id = 1

    an__[id][1] = nar

    an__[id][2:end] = co_

    for (id, ro) in enumerate(ro_)

        id = 1 + id

        an__[id][1] = ro

        an__[id][2:end] = [get(ro_an, ro, missing) for ro_an in ro_an__]

    end

    make(an__)

end

# TODO: Benchmark against _DataFrame(roma, roco_).
function make(ro, ro_, co_, ma)

    insertcols!(_DataFrame(ma, co_), 1, ro => ro_)

end

function separate(da)

    co_ = names(da)

    id_ = 2:length(co_)

    co_[1],
    # TODO: Benchmark against map(string, da[!, 1]).
    da[:, 1]::Vector{<:AbstractString},
    co_[id_]::Vector{String},
    Matrix(da[!, id_])

end

function collapse(da; fu = mean, ty = Float64)

    si = size(da)

    @info "Size before collapsing is $si."

    ro_id_ = OrderedDict{String, Vector{Int}}()

    nar, ro_, co_, ma = separate(da)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, Vector{Int}()), id)

    end

    n = length(ro_id_)

    if length(ro_) == n

        @warn "There are no rows to collapse."

        return da

    end

    ro2_ = Vector{String}(undef, n)

    ma2 = Matrix{ty}(undef, (n, length(co_)))

    for (id2, (ro, id_)) in enumerate(ro_id_)

        ro2_[id2] = ro

        if length(id_) == 1

            an_ = ma[id_[1], :]

        else

            # TODO: Benchmark against view(ma, id_, :)
            # TODO: Benchmark against map(fu, eachcol(ma[id_, :]))
            an_ = [fu(an_) for an_ in eachcol(ma[id_, :])]

        end

        ma2[id2, :] = an_

    end

    da2 = make(nar, ro2_, co_, ma2)

    si2 = size(da2)

    @info "Size after is $si2."

    da2

end

function map(da, fu!, fr_, to; de = "")

    daf = da[!, fr_]

    to_ = da[!, to]

    fr_to = Dict{
        typejoin((eltype(skipmissing(co)) for co in eachcol(daf))...),
        eltype(skipmissing(to_)),
    }()

    for (fr_, to) in zip(eachrow(daf), to_)

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
