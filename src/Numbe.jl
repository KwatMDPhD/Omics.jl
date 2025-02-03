module Numbe

using Printf: @sprintf

function shorten(nu)

    @sprintf "%.2g" nu

end

function categorize(nu, ma_, ca_)

    ca_[findfirst(>=(nu), ma_)]

end

end
