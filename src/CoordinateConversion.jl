module CoordinateConversion

function make_unit(an_)

    po = Matrix{Float64}(undef, 2, lastindex(an_))

    po[1, :] = an_

    po[2, :] .= 1.0

    po

end

function convert_cartesian_to_polar(xc, yc)

    an = atan(yc / xc)

    if xc < 0

        an += pi

    elseif yc < 0

        an += 2.0 * pi

    end

    an, sqrt(xc^2 + yc^2)

end

function convert_polar_to_cartesian(an, ra)

    si, co = sincos(an)

    co * ra, si * ra

end

function convert_cartesian_to_polar(ca)

    po = similar(ca)

    for id in axes(po, 2)

        po[1, id], po[2, id] = convert_cartesian_to_polar(ca[1, id], ca[2, id])

    end

    po

end

function convert_polar_to_cartesian(po)

    ca = similar(po)

    for id in axes(ca, 2)

        ca[1, id], ca[2, id] = convert_polar_to_cartesian(po[1, id], po[2, id])

    end

    ca

end

end
