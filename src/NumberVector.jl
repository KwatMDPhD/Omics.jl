module NumberVector

using Distributions: Normal

using ..BioLab

function force_increasing_with_min!(ar)

    reverse!(accumulate!(min, ar, reverse!(ar)))

end

function force_increasing_with_max!(ar)

    accumulate!(max, ar, ar)

end

function _simulate(n)

    ra_ = rand(Normal(), n)

    po_ = BioLab.NumberArray.shift_minimum(ra_, 0)

    sort!(po_)

    reverse(-po_), po_

end

function _concatenate(ne_, ze, po_)

    vcat(ne_[1:(end - !ze)], po_)

end

function simulate(n; ze = true)

    ne_, po_ = _simulate(n)

    _concatenate(ne_, ze, po_)

end

function simulate_deep(n; ze = true)

    ne_, po_ = _simulate(n)

    _concatenate(ne_ * 2, ze, po_)

end

function simulate_wide(n; ze = true)

    ne_, po_ = _simulate(n)

    ne2_ = Vector{Float64}(undef, n * 2 - 1)

    for (id, ne) in enumerate(ne_)

        id2 = id * 2

        ne2_[id2 - 1] = ne

        if id < n

            ne2_[id2] = (ne + ne_[id + 1]) / 2

        end

    end

    _concatenate(ne2_, ze, po_)

end

end
