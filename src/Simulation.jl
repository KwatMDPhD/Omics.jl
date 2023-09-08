module Simulation

using Distributions: Normal

using ..BioLab

function _mirror(n)

    ra_ = rand(Normal(), n)

    po_ = ra_ .+ (0 - minimum(ra_))

    sort!(po_)

    reverse(-po_), po_

end

function _concatenate(ne_, ze, po_)

    n = length(ne_)

    vcat(view(ne_, 1:(n - !ze)), po_)

end

function mirror(n; ze = true)

    ne_, po_ = _mirror(n)

    _concatenate(ne_, ze, po_)

end

function mirror_deep(n; ze = true)

    ne_, po_ = _mirror(n)

    _concatenate(ne_ * 2, ze, po_)

end

function mirror_wide(n; ze = true)

    ne_, po_ = _mirror(n)

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

function make_matrix_1n(ty, n_ro, n_co)

    convert(Matrix{ty}, reshape(1:(n_ro * n_co), n_ro, n_co))

end

end
