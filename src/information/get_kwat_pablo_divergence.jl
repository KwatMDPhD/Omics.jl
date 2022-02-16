function get_kwat_pablo_divergence(te1, te2, ve; we1 = 1 / 2, we2 = 1 / 2)

    get_kullback_leibler_divergence(te1, ve) .* we1 .-
    get_kullback_leibler_divergence(te2, ve) .* we2

end
