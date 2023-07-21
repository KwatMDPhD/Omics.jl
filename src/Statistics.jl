module Statistics

using Distributions: Normal, quantile

function get_z_score(fr)

    quantile(Normal(), fr)

end

function get_confidence_interval(fr)

    fr = (1 - fr) / 2

    get_z_score(fr), get_z_score(1 - fr)

end

end
