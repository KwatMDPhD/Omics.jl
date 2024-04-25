module Triangulation

using DelaunayTriangulation: get_convex_hull_indices, get_points

using LazySets: VPolygon, Singleton, element

function bound(tr)

    VPolygon(get_points(tr)[get_convex_hull_indices(tr)])

end

function is_in(xy, vp)

    element(Singleton(xy)) ∈ vp

end

end
