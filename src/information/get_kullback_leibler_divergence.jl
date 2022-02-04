function get_kullback_leibler_divergence(
    ve1::Vector{Float64},
    ve2::Vector{Float64},
)::Vector{Float64}
    
    # TODO: confirm that the log is base 2
    return ve1 .* log.(ve1 ./ ve2)

end
