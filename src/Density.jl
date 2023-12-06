module Density

# TODO: https://github.com/panlanfeng/KernelEstimator.jl/blob/master/src/bandwidth.jl.
using KernelDensity: default_bandwidth, kde

function get_bandwidth(nu_)

    default_bandwidth(nu_)

end

function estimate(nu___; ke_ar...)

    de = kde(nu___; ke_ar...)

    de.x, de.y, de.density

end

end
