module DataFrame

using DataFrames: DataFrame as _DataFrame, insertcols!

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

    ro_ = sort!(collect(union(Base.map(keys, ro_an__)...)))

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
    # TODO: Benchmark against Base.map(string, da[!, 1]).
    da[:, 1]::Vector{<:AbstractString},
    co_[id_]::Vector{String},
    Matrix(da[!, id_])

end

# TODO: Test.
function collapse(fu, ty, da)

    nar, ro_, co_, ma = separate(da)

    ro2_ma2 = BioLab.NumberMatrix.collapse(fu, ty, ro_, ma)

    if isnothing(ro2_ma2)

        nothing

    else

        ro2_, ma2 = ro2_ma2

        make(nar, ro2_, co_, ma2)

    end

end

function map(da, fu!, fr_, to; de = "")

    daf = da[!, fr_]

    to_ = da[!, to]

    tyt = eltype(skipmissing(to_))

    fr_to = Dict{typejoin(tyt, (eltype(skipmissing(co)) for co in eachcol(daf))...), tyt}()

    println(fr_to)

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
