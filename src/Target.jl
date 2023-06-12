module Target

using ..BioLab

function _aim(nu1_, nu2_)

    BioLab.Array.error_size_difference((nu1_, nu2_))

    nu1_, nu2_

end

function _aim(bo_::AbstractVector{Bool}, nu_)

    BioLab.Array.error_size_difference((bo_, nu_))

    nu_[map(!, bo_)], nu_[bo_]

end

function _trigger(fu, nu1_, nu2_)

    nu1a_, nu2a_ = _aim(nu1_, nu2_)

    fu(nu1a_, nu2a_)

end

function target(fu, nu1_, fe_x_sa_x_nu2)

    map(nu2_ -> _trigger(fu, nu1_, nu2_), eachrow(fe_x_sa_x_nu2))

end

end
