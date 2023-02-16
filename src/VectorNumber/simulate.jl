# TODO: Multiple-dispatch.
function simulate(n; ra = BioLab.Constant.RA, di = Normal(), ho = "", re = true)

    # TODO: Check correctness.
    seed!(ra)

    ra_ = rand(di, n)

    po_ = shift_minimum(ra_, 0.0)

    sort!(po_)

    ne_ = reverse(-po_)

    if isempty(ho)

        nem_ = ne_

    elseif ho == "deep"

        nem_ = ne_ * 2.0

    elseif ho == "long"

        # TODO: Use `Float64`.
        nem_ = Vector{eltype(ne_)}(undef, n * 2 - 1)

        for (id, ne) in enumerate(ne_)

            id2 = id * 2

            nem_[id2 - 1] = ne

            if id < n

                nem_[id2] = (ne + ne_[id + 1]) / 2.0

            end

        end

    else

        error()

    end

    if !re

        nem_ = nem_[1:(end - 1)]

    end

    # TODO: Preallocate.
    return vcat(nem_, po_)

end
