module Probability

using ..Nucleus

# TODO: Test.
function get_joint(i1_::AbstractVector{<:Integer}, i2_::AbstractVector{<:Integer})

    Nucleus.Collection.count(i1_, i2_) / lastindex(i1_)

end

# TODO: Test.
function get_joint(n1_, n2_; ke_ar...)

    _ro, _co, de = Nucleus.Density.estimate((n2_, n1_); ke_ar...)

    de / sum(de)

end

end
