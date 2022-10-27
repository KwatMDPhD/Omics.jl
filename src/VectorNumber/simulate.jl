function simulate(n, re = true, ra = OnePiece.Constant.RA; di = "Normal", mi = "")

    #
    if di == "Normal"

        di = Normal()

    end

    #
    seed!(ra)

    ra_ = rand(di, n)

    #
    po_ = shift_minimum(ra_, 0)

    sort!(po_)

    ne_ = reverse(-po_)

    #
    if mi == ""

        ne2_ = ne_

    elseif mi == "deep"

        ne2_ = ne_ * 2.0

    elseif mi == "long"

        ne2_ = Vector{eltype(ne_)}(undef, n * 2 - 1)

        for (id, ne) in enumerate(ne_)

            id2 = id * 2

            ne2_[id2 - 1] = ne

            if id < n

                ne2_[id2] = (ne + ne_[id + 1]) / 2

            end

        end

    end

    #
    if !re

        ne2_ = ne2_[1:(end - 1)]

    end

    #
    vcat(ne2_, po_)

end
