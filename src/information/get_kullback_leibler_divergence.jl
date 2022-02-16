function get_kullback_leibler_divergence(te1, te2)

    te1 .* log.(te1 ./ te2)

end
