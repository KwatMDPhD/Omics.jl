function get_jensen_shannon_divergence(te1, te2, te; we1 = 1 / 2, we2 = 1 / 2)

    get_kullback_leibler_divergence(te1, te) .* we1 .+
    get_kullback_leibler_divergence(te2, te) .* we2

end
