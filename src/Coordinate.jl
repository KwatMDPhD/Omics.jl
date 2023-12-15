module Coordinate

using DelaunayTriangulation: get_convex_hull_indices, get_points, triangulate

using LazySets: VPolygon, Singleton, element

using MultivariateStats: MetricMDS, fit

using ..Nucleus

function get(an_x_an_x_di, maxoutdim = 2)

    fit(MetricMDS, an_x_an_x_di; distances = true, maxoutdim, maxiter = 10^3).X

end

function pull(di_x_no_x_co, no_x_po_x_pu, pu = 1)

    if isone(pu)

        no_x_po_x_pu = copy(no_x_po_x_pu)

    else

        no_x_po_x_pu = no_x_po_x_pu .^ pu

    end

    foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(no_x_po_x_pu))

    di_x_no_x_co * no_x_po_x_pu

end

function wall(tr)

    VPolygon(get_points(tr)[get_convex_hull_indices(tr)])

end

function is_in(co_, vp)

    element(Singleton(co_)) ∈ vp

end

end
