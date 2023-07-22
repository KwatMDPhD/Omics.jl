module Target

using BioLab

function _aim(nu1_, nu2_)

    nu1_, nu2_

end

function _aim(bo_::AbstractVector{Bool}, nu_)

    nu_[map(!, bo_)], nu_[bo_]

end

function _trigger(fu, nu1_, nu2_)

    nu1a_, nu2a_ = _aim(nu1_, nu2_)

    fu(nu1a_, nu2a_)

end

function target(fu, nu1_, ma2)

    map(nu2_ -> _trigger(fu, nu1_, nu2_), eachrow(ma2))

end

end
