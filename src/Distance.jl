module Distance

using Distances: Euclidean, pairwise

function get(fu, an___)

    pairwise(fu, an___)

end

function get_half(fu, an___)

    n_an = lastindex(an___)

    an_x_an_x_di = Matrix{Float64}(undef, n_an, n_an)

    for id1 in 1:n_an

        an_x_an_x_di[id1, id1] = 0.0

        an1_ = an___[id1]

        for id2 in (id1 + 1):n_an

            an_x_an_x_di[id1, id2] = an_x_an_x_di[id2, id1] = fu(an1_, an___[id2])

        end


    end

    an_x_an_x_di

end

end
