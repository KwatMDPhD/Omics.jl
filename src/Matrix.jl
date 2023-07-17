module Matrix

function make(ve_)

    [ve_[id1][id2] for id1 in eachindex(ve_), id2 in eachindex(ve_[1])]

end

end
