function sort_like(ve_, de = false)

    id_ = sortperm(ve_[1], rev = de)

    [ve[id_] for ve in ve_]

end
