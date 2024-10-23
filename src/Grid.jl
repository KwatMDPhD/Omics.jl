module Grid

function make(nu_, ug)

    mi, ma = extrema(nu_)

    range(mi, ma, ug)

end

function find(gr_, nu)

    for id in eachindex(gr_)

        if nu <= gr_[id]

            return id

        end

    end

    lastindex(gr_)

end

end
