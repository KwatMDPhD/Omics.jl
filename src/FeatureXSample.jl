module FeatureXSample

using ..BioLab

function _aim(nu1_, nu2_)

    BioLab.Array.error_size(nu1_, nu2_)

    return nu1_, nu2_

end

function _aim(bo_::AbstractVector{Bool}, nu_)

    BioLab.Array.error_size(bo_, nu_)

    return nu_[[!bo for bo in bo_]], nu_[bo_]

end

function _trigger(fu, nu1_, nu2_)

    nu1a_, nu2a_ = _aim(nu1_, nu2_)

    return fu(nu1a_, nu2a_)

end

function target(fu, nu1_, fe_x_sa_x_nu2)

    return [_trigger(fu, nu1_, nu2_) for nu2_ in eachrow(fe_x_sa_x_nu2)]

end

end
