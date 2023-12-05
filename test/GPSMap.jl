using Nucleus

using DelaunayTriangulation: get_edges, triangulate

using Distances: pairwise

using KernelDensity: kde

using LazySets: VPolygon, Singleton, element

using MultivariateStats: MetricMDS, fit

using Random: seed!

# ---- #

_naf, fa_, sa_, mh = Nucleus.DataFrame.separate(
    expanduser("~/Downloads/onco_gps_paper_analysis-master/output/nmfccs/nmf_k9_h.txt"),
)

Nucleus.Plot.plot_heat_map("", mh; y = fa_, x = sa_)

# ---- #

function cluster(z, y, x)

    id2_ = Nucleus.Clustering.hierarchize(z).order

    id1_ = Nucleus.Clustering.hierarchize(permutedims(z)).order

    z[id1_, id2_], y[id1_], x[id2_]

end

# ---- #

for co in eachcol(mh)

    Nucleus.Normalization.normalize_with_0!(co)

    clamp!(co, -3, 3)

    Nucleus.Normalization.normalize_with_01!(co)

end

z, y, x = cluster(mh, fa_, sa_)

Nucleus.Plot.plot_heat_map("", z; y, x)

# ---- #

_nag, gr_, _sa_, gr_x_sa_x_la = Nucleus.DataFrame.separate(
    expanduser("~/Downloads/onco_gps_paper_analysis-master/output/global_hccs/hccs.txt"),
)

@assert sa_ == _sa_

la_ = gr_x_sa_x_la[findfirst(==("K15"), gr_), :] .+ 1

Nucleus.Plot.plot_heat_map("", mh; y = fa_, x = sa_, grc_ = la_)

# ---- #

po_x_no_x_pu = permutedims(mh)

po_x_no_x_pu .^= 2

no_x_id_x_co = permutedims(
    fit(
        MetricMDS,
        pairwise(Nucleus.Information.get_information_coefficient_distance, eachrow(mh));
        distances = true,
        maxoutdim = 2,
    ).X,
)

# ---- #

po_x_id_x_co =
    [sum(co_ .* pu_) / sum(pu_) for pu_ in eachrow(po_x_no_x_pu), co_ in eachcol(no_x_id_x_co)]

# ---- #

no_ = fa_

node_marker_size = 48

node_marker_color = "#23191e"

arrowwidth = 1.6

arrowcolor = Nucleus.Color.HEFA

po_ = sa_

point_marker_size = 16

point_marker_opacity = 0.88

la_ = la_

co_ = (
    "#e74c3c",
    "#ffd700",
    "#4b0082",
    "#993300",
    "#4169e1",
    "#90ee90",
    "#f4bd60",
    "#8b008b",
    "#fa8072",
    "#b0e0e6",
    "#20d9ba",
    "#da70d6",
    "#d2691e",
    "#dc143c",
    "#2e8b57",
)

# ---- #

seed!(202312042237)

# ---- #

axis = Dict("showgrid" => false, "zeroline" => false, "showticklabels" => true)

layout = Dict(
    "title" => Dict("text" => "GPS Map"),
    "yaxis" => axis,
    "xaxis" => axis,
    "annotations" => Dict{String, Any}[],
)

data = Dict{String, Any}[]

tr = triangulate([(ro[2], ro[1]) for ro in eachrow(no_x_id_x_co)])

for id_ in get_edges(tr)

    if any(==(-1), id_)

        continue

    end

    id1, id2 = id_

    push!(
        data,
        Dict(
            "showlegend" => false,
            "y" => (no_x_id_x_co[id1, 1], no_x_id_x_co[id2, 1]),
            "x" => (no_x_id_x_co[id1, 2], no_x_id_x_co[id2, 2]),
            "mode" => "lines",
            "line" => Dict("color" => "#171412"),
        ),
    )

end

push!(
    data,
    Dict(
        "name" => "Node",
        "y" => no_x_id_x_co[:, 1],
        "x" => no_x_id_x_co[:, 2],
        "text" => fa_,
        "mode" => "markers",
        "marker" => Dict(
            "size" => node_marker_size,
            "color" => node_marker_color,
            "line" => Dict("width" => node_marker_size / 16, "color" => Nucleus.Color.HEFA),
        ),
        "hoverinfo" => "text",
    ),
)

for (fa, (y, x)) in zip(fa_, eachrow(no_x_id_x_co))

    push!(
        layout["annotations"],
        Dict(
            "y" => y,
            "x" => x,
            "text" => "<b>$fa</b>",
            "font" => Dict(
                "size" => 16,
                "color" => node_marker_color,
                "family" => "Gravitas One, monospace",
            ),
            "borderpad" => 2,
            "borderwidth" => arrowwidth,
            "bordercolor" => arrowcolor,
            "bgcolor" => "#ffffff",
            "arrowwidth" => arrowwidth,
            "arrowcolor" => arrowcolor,
        ),
    )

end

trace = Dict(
    "name" => "Point",
    "mode" => "markers",
    "marker" => Dict(
        "size" => point_marker_size,
        "color" => Nucleus.Color.HEGE,
        "line" => Dict("width" => point_marker_size / 16, "color" => "#898a74"),
        "opacity" => point_marker_opacity,
    ),
    "hoverinfo" => "text",
)

kd = kde((po_x_id_x_co[:, 2], po_x_id_x_co[:, 1]); npoints = (256, 256))

po = VPolygon([[no_x_id_x_co[id, 2], no_x_id_x_co[id, 1]] for id in tr.convex_hull.indices])

is = [element(Singleton([x, y])) ∈ po for x in collect(kd.x), y in kd.y]

kd.density[.!is] .= NaN

push!(
    data,
    Dict(
        "type" => "contour",
        "showlegend" => false,
        "y" => kd.y,
        "x" => kd.x,
        "z" => kd.density,
        "autocontour" => false,
        "ncontours" => 24,
        "contours" => Dict("coloring" => "none"),
    ),
)

if isnothing(la_)

    push!(
        data,
        merge(trace, Dict("y" => po_x_id_x_co[:, 1], "x" => po_x_id_x_co[:, 2], "text" => sa_)),
    )

else

    un_ = unique(la_)

    if isempty(co_)

        co_ = Nucleus.Color.color(un_)

    end

    for (la, color) in zip(un_, co_)

        id_ = findall(==(la), la_)

        push!(
            data,
            Nucleus.Dict.merge(
                trace,
                Dict(
                    "legendgroup" => la,
                    "name" => la,
                    "y" => po_x_id_x_co[id_, 1],
                    "x" => po_x_id_x_co[id_, 2],
                    "text" => sa_[id_],
                    "marker" => Dict("color" => color),
                ),
            ),
        )

    end

end

Nucleus.Plot.plot("", data, layout)

# ---- #

kd = kde((1:7, [2, 3, 4, 8, 16, 32, 128]), npoints = (8, 16))

Nucleus.Plot.plot_heat_map("", permutedims(kd.density); y = kd.y, x = kd.x)
