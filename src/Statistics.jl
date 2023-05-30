module Statistics

using Distributions: Normal, quantile

function get_z_score(cu)

    return quantile(Normal(), cu)

end

function get_confidence_interval(co)

    cu = (1.0 - co) / 2.0

    return get_z_score(cu), get_z_score(1.0 - cu)

end

end
