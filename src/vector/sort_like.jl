function sort_like(v_::Vector...; r::Bool = false)::Vector{Vector}

    i_ = sortperm(v_[1]; rev = r)

    return [v[i_] for v in v_]

end

export sort_like
