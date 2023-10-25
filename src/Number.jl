module Number

function is_negative(it)

    it < 0

end

function is_negative(fl::AbstractFloat)

    fl < 0 || fl === -0.0

end

# TODO: Test.
# TODO: Benchmark `fl_`.
function separate(nu_)

    ne_ = Float64[]

    po_ = Float64[]

    for nu in nu_

        if is_negative(nu)

            fl_ = ne_

        else

            fl_ = po_

        end

        push!(fl_, nu)

    end

    ne_, po_

end

end
