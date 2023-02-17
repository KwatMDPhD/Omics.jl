module VectorNumber

using Distributions: Normal

using Random: seed!

using ..BioLab

function get_extreme(nu_)

    mi = minimum(nu_)

    ma = maximum(nu_)

    mia = abs(mi)

    maa = abs(ma)

    if isapprox(mia, maa)

        return (mi, ma)

    elseif maa < mia

        return (mi,)

    elseif mia < maa

        return (ma,)

    else

        error()

    end

end

# TODO: Multiple-dispatch.
function simulate(n; ra = BioLab.RA, di = Normal(), ho = "", re = true)

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

        nem_ = Vector{Float64}(undef, n * 2 - 1)

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

function shift_minimum(nu_, mi::Real)

    sh = mi - minimum(nu_)

    return [nu + sh for nu in nu_]

end

function shift_minimum(nu_, st)

    fl = parse(eltype(nu_), BioLab.String.split_and_get(st, '<', 1))

    return shift_minimum(nu_, minimum(nu_[[fl < nu for nu in nu_]]))

end

end
