function sort_like(an__; de = false)

    so_ = sortperm(an__[1]; rev = de)

    [an_[so_] for an_ in an__]

end
