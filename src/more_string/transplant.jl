function transplant(st1::String, st2::String, de::String, id_::Vector{Int64})::String

    sp1_ = split(st1, de)

    sp2_ = split(st2, de)

    @assert length(sp1_) == length(sp2_)

    return join([[sp1, sp2][id] for (sp1, sp2, id) in zip(sp1_, sp2_, id_)], de)

end
