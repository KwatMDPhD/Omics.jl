module Coordinate

using DelaunayTriangulation: get_convex_hull_indices, get_points, triangulate

using LazySets: VPolygon, Singleton, element

using MultivariateStats: MetricMDS, fit

using ..Nucleus

function get(di, maxoutdim = 2)

    fit(MetricMDS, di; distances = true, maxoutdim, maxiter = 10^3).X

end

function pull(dn, np, pu = 1)

    np = isone(pu) ? copy(np) : np .^ pu

    foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(np))

    dn * np

end

function wall(tr)

    VPolygon(get_points(tr)[get_convex_hull_indices(tr)])

end

function is_in(co_, vp)

    element(Singleton(co_)) ∈ vp

end

end
