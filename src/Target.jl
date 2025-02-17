module Target

function go(fu, bo_::Union{Vector{Bool}, BitVector}, nu_)

    fu(nu_[map(!, bo_)], nu_[bo_])

end

end
