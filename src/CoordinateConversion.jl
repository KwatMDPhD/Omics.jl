module CoordinateConversion

function make_unit(an_)

    pa = Matrix{Float64}(undef, 2, lastindex(an_))

    pa[1, :] = an_

    pa[2, :] .= 1

    pa

end

function convert_cartesian_to_polar(xc, yc)

    an = atan(yc / xc)

    if xc < 0

        an += pi

    elseif yc < 0

        an += 2 * pi

    end

    an, sqrt(xc^2 + yc^2)

end

function convert_polar_to_cartesian(an, ra)

    si, co = sincos(an)

    co * ra, si * ra

end

function convert_cartesian_to_polar(ca)

    pa = similar(ca)

    for id in axes(pa, 2)

        an, ra = convert_cartesian_to_polar(ca[1, id], ca[2, id])

        pa[1, id] = an

        pa[2, id] = ra

    end

    pa

end

function convert_polar_to_cartesian(pa)

    ca = similar(pa)

    for id in axes(ca, 2)

        xc, yc = convert_polar_to_cartesian(pa[1, id], pa[2, id])

        ca[1, id] = xc

        ca[2, id] = yc

    end

    ca

end

end
