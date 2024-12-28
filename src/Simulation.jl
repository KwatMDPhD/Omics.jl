module Simulation

function _mirror(up)

    po_ = Vector{Float64}(undef, up)

    id = 1

    po_[id] = 0.0

    while id < up

        ra = randn()

        if 0.0 < ra

            po_[id += 1] = ra

        end

    end

    sort!(po_)

    reverse!(-po_), po_

end

function _concatenate(ne_, ze, po_)

    vcat(ne_[1:(end - !ze)], po_)

end

function make_vector_mirror(up, ze = true)

    ne_, po_ = _mirror(up)

    _concatenate(ne_, ze, po_)

end

function make_vector_mirror_deep(up, ze = true)

    ne_, po_ = _mirror(up)

    _concatenate(ne_ * 2.0, ze, po_)

end

function make_vector_mirror_wide(up, ze = true)

    ne_, po_ = _mirror(up)

    ng_ = Vector{Float64}(undef, up * 2 - 1)

    for id in eachindex(ne_)

        ie = id * 2

        ne = ne_[id]

        ng_[ie - 1] = ne

        if id < up

            ng_[ie] = (ne + ne_[id + 1]) * 0.5

        end

    end

    _concatenate(ng_, ze, po_)

end

function make_matrix_1n(ty, ur, uc)

    Matrix{ty}(reshape(1:(ur * uc), ur, uc))

end

function label(ul, la = "Label")

    map(id -> "$la $id", 1:ul)

end

end
