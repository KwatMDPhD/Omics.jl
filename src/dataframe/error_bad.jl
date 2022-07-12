function error_bad(da::DataFrame)

    na_ba = OrderedDict()

    na_ = names(da)

    co_ = eachcol(da)

    for id in 1:ncol(da)

        na = na_[id]

        co = co_[id]

        for va in co

            if va isa String

                continue

            end

            if any(is(va) for is in [ismissing, isnothing, isnan, isinf])

                if !haskey(na_ba, na)

                    na_ba[na] = Any[]

                end

                push!(na_ba[na], va)

            end

        end

    end

    if !isempty(na_ba)

        OnePiece.dict.print(na_ba, n_pa = 8)

        error()

    end

end
