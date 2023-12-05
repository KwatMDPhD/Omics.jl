module Distance

using Distances: Euclidean, pairwise

function get_distance(an___, fu = Euclidean())

    pairwise(fu, an___)

end

end
