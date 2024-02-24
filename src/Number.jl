module Number

using Printf: @sprintf

using ..Nucleus

function format2(nu)

    @sprintf "%.2g" nu

end

function format4(nu)

    @sprintf "%.4g" nu

end

function categorize(nu, nu_, ca_)

    i1 = findfirst(>(nu), nu_)

    ca_[isnothing(i1) ? end : i1]

end

function separate(nu_)

    ne_ = Float64[]

    po_ = Float64[]

    for nu in nu_

        push!(nu < 0 ? ne_ : po_, nu)

    end

    ne_, po_

end

function ready(nu_::AbstractVector{<:Real})

    nu_

end

function ready(an_)

    an_i1 = Nucleus.Collection._map_index(sort!(unique(an_)))

    [an_i1[an] for an in an_]

end

end
