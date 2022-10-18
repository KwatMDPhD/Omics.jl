function get_antisymmetric_kullback_leibler_divergence(ve1, ve2, ve; we1 = 1 / 2, we2 = 1 / 2)

    get_kullback_leibler_divergence(ve1, ve) .* we1 .-
    get_kullback_leibler_divergence(ve2, ve) .* we2

end
