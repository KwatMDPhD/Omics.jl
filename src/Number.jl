module Number

function is_negative(it)

    it < 0

end

function is_negative(fl::AbstractFloat)

    fl < 0 || fl === -0.0

end

# TODO: Test.
function separate(nu_)

    ne_ = Float64[]

    po_ = Float64[]

    for nu in nu_

        push!(is_negative(nu) ? ne_ : po_, nu)

    end

    ne_, po_

end

end
