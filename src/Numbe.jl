module Numbe

using Printf: @sprintf

function shorten(nu)

    @sprintf "%.2g" nu

end

function categorize(nu, nu_, ca_)

    ca_[findfirst(>(nu), nu_) - 1]

end

end
