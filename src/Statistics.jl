module Statistics

using Distributions: Normal, quantile

function get_z_score(cu)

    quantile(Normal(), cu)

end

end
