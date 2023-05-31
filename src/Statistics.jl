module Statistics

using Distributions: Normal, quantile

function get_z_score(cu)

    quantile(Normal(), cu)

end

function get_confidence_interval(co)

    cu = (1 - co) / 2

    get_z_score(cu), get_z_score(1 - cu)

end

end
