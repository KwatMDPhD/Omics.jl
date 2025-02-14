module Grid

function make(nu_, um)

    mi, ma = extrema(nu_)

    range(mi, ma, um)

end

function find(gr_, nu)

    id = findfirst(>=(nu), gr_)

    isnothing(id) ? lastindex(gr_) : id

end

end
