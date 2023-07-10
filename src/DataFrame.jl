module DataFrame

using DataFrames: DataFrame as _DataFrame, insertcols!

using BioLab

function make(ve_)

    _DataFrame(BioLab.Matrix.make(ve_[2:end]), ve_[1])

end

function make(nar, ro_, co_, ma)

    insertcols!(_DataFrame(ma, co_), 1, nar => ro_)

end

function separate(da)

    co_ = names(da)

    id_ = 2:length(co_)

    co_[1], da[:, 1], view(co_, id_), Matrix(da[!, id_])

end

function map(da, fu!, fr_, to; de = "")

    daf = da[!, fr_]

    to_ = da[!, to]

    tyt = eltype(skipmissing(to_))

    fr_to = Dict{typejoin(tyt, (eltype(skipmissing(co)) for co in eachcol(daf))...), tyt}()

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
