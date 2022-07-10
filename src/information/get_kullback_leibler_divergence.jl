function get_kullback_leibler_divergence(ve1, ve2)

    ve1 .* log.(ve1 ./ ve2)

end
