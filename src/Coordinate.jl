module Coordinate

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

end
