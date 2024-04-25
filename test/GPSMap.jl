using Test: @test

using Nucleus

# ---- #

using Distances: CorrDist, Euclidean, pairwise

using Random: seed!

# ---- #

const DA = joinpath(Nucleus._DA, "GPSMap")

# ---- #

@test Nucleus.Path.read(DA) == ["grouping_x_sample_x_group.tsv", "h.tsv", "w.tsv"]

# ---- #

function cluster_plot(ht, ro_, co_, rc)

    i1_ = Nucleus.Clustering.hierarchize(CorrDist(), eachrow(rc)).order

    i2_ = Nucleus.Clustering.hierarchize(CorrDist(), eachcol(rc)).order

    Nucleus.Plot.plot_heat_map(ht, rc[i1_, i2_]; y = ro_[i1_], x = co_[i2_])

end

# ---- #

_nf, fa_, sa_, H = Nucleus.DataFrame.separate(joinpath(DA, "h.tsv"))

cluster_plot(joinpath(Nucleus.TE, "h.html"), fa_, sa_, H)

# ---- #

foreach(Nucleus.Normalization.normalize_with_0!, eachrow(H))

clamp!(H, -3, 3)

foreach(Nucleus.Normalization.normalize_with_01!, eachrow(H))

cluster_plot(joinpath(Nucleus.TE, "h_normalized.html"), fa_, sa_, H)

# ---- #

_ng, gr_, _sa_, la = Nucleus.DataFrame.separate(joinpath(DA, "grouping_x_sample_x_group.tsv"))

@assert sa_ == _sa_

la_ = la[findfirst(==("K15"), gr_), :] .+ 1

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "h_labeled.html"), H; y = fa_, x = sa_, gc_ = la_)

# ---- #

const NN = pairwise(Nucleus.Distance.InformationDistance(), eachrow(H))

cluster_plot(joinpath(Nucleus.TE, "distance.html"), fa_, fa_, NN)

# ---- #

seed!(202312091501)

const DN = Nucleus.Coordinate.get(NN)

# ---- #

const DP = Nucleus.Coordinate.pull(DN, mh, 1.5)

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "point.html"),
    DP;
    y = ["Dimension 1", "Dimension 2"],
    x = sa_,
    gc_ = la_,
    fu = Euclidean(),
)

# ---- #

const point_marker_size = 8

# ---- #

Nucleus.GPSMap.plot(joinpath(Nucleus.TE, "map.html"), fa_, DN, sa_, DP; point_marker_size)

# ---- #

Nucleus.GPSMap.plot(
    joinpath(Nucleus.TE, "map_with_score.html"),
    fa_,
    DN,
    sa_,
    DP;
    sc_ = la_,
    sc_na = Dict(i1 => "State $i1" for i1 in 1:15),
    point_marker_size,
)

# ---- #

seed!(202404241617)

an_, ob_, te_, ac_ = Nucleus.Polar.anneal(NN)

Nucleus.Polar.plot_annealing(joinpath(Nucleus.TE, "annealing.html"), ob_, te_, ac_)

# ---- #

pn = Matrix{Float64}(undef, 2, lastindex(an_))

pn[1, :] = an_

pn[2, :] .= 1

# ---- #

cn = Nucleus.Polar.convert_polar_to_cartesian(pn)

CP = Nucleus.Coordinate.pull(cn, mh, 1.5)

pp = Nucleus.Polar.convert_cartesian_to_polar(CP)

# ---- #

Nucleus.Plot.plot(
    joinpath(Nucleus.TE, "polar.html"),
    [
        Dict(
            "type" => "scatterpolar",
            "name" => "Node",
            "theta" => pn[1, :] / pi * 180,
            "r" => pn[2, :],
            "text" => fa_,
            "mode" => "markers",
            "marker" => Dict("size" => 48, "color" => "#ffff00"),
        ),
        Dict(
            "type" => "scatterpolar",
            "name" => "Point",
            "theta" => pp[1, :] / pi * 180,
            "r" => pp[2, :],
            "text" => sa_,
            "mode" => "markers",
            "marker" => Dict("size" => point_marker_size, "color" => "#00ffff"),
        ),
    ],
    Dict(
        "polar" => Dict(
            "angularaxis" =>
                Dict("showgrid" => false, "ticks" => "", "showticklabels" => false),
            "radialaxis" => Dict(
                "showline" => false,
                "showgrid" => false,
                "ticks" => "",
                "showticklabels" => false,
            ),
        ),
    ),
)

# ---- #

Nucleus.GPSMap.plot(
    joinpath(Nucleus.TE, "polar.html"),
    fa_,
    cn,
    sa_,
    CP;
    sc_ = la_,
    sc_na = Dict(i1 => "State $i1" for i1 in 1:15),
    point_marker_size,
    layout = Dict("showlegend" => false, "legend" => Dict()),
)
