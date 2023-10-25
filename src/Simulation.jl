module Simulation

using ..Nucleus

function _mirror(n)

    po_ = Vector{Float64}(undef, n)

    id = 1

    po_[id] = 0

    while id < n

        ra = randn()

        if !Nucleus.Number.is_negative(ra)

            po_[id += 1] = ra

        end

    end

    sort!(po_)

    reverse!(-po_), po_

end

function _concatenate(ne_, ze, po_)

    vcat(ne_[1:(end - !ze)], po_)

end

function make_vector_mirror(n, ze = true)

    ne_, po_ = _mirror(n)

    _concatenate(ne_, ze, po_)

end

function make_vector_mirror_deep(n, ze = true)

    ne_, po_ = _mirror(n)

    _concatenate(2ne_, ze, po_)

end

function make_vector_mirror_wide(n, ze = true)

    ne_, po_ = _mirror(n)

    new_ = Vector{Float64}(undef, 2n - 1)

    for (id, ne) in enumerate(ne_)

        id2 = 2id

        new_[id2 - 1] = ne

        if id < n

            new_[id2] = 0.5(ne + ne_[id + 1])

        end

    end

    _concatenate(new_, ze, po_)

end

function make_matrix_1n(ty, n_ro, n_co)

    Matrix{ty}(reshape(1:(n_ro * n_co), n_ro, n_co))

end

end
