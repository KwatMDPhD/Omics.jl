module Number

using Printf: @sprintf

using ..Nucleus

function format2(nu)

    @sprintf "%.2g" nu

end

function format4(nu)

    @sprintf "%.4g" nu

end

function is_negative(it)

    it < 0

end

function is_negative(fl::AbstractFloat)

    fl < 0 || fl === -0.0

end

function shift!(nu_, mi = 1)

    nu_ .-= minimum(nu_)

    nu_ .+= mi

end

function separate(nu_)

    ne_ = Float64[]

    po_ = Float64[]

    for nu in nu_

        push!(is_negative(nu) ? ne_ : po_, nu)

    end

    ne_, po_

end

function ready(nu_::AbstractVector{<:Real})

    nu_

end

function ready(an_)

    an_i1 = Nucleus.Collection.map_index(sort!(unique(an_)))

    [an_i1[an] for an in an_]

end

end
