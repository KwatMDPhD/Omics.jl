function sort_like(ve_::Vector...; re::Bool = false)::Vector{Vector}

    ie_ = sortperm(ve_[1]; rev = re)

    return [ve[ie_] for ve in ve_]

end

export sort_like
