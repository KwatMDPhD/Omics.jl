module Numbe

using Printf: @sprintf

function shorten(nu)

    @sprintf "%.2g" nu

end

function categorize(nu, ma_, gr_)

    gr_[findfirst(>=(nu), ma_)]

end

function separate(nu_)

    ty = eltype(nu_)

    ne_ = ty[]

    po_ = ty[]

    for nu in nu_

        push!(nu < 0 ? ne_ : po_, nu)

    end

    ne_, po_

end

end
