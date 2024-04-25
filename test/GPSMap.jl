using Test: @test

using Nucleus

# ---- #

using Distances: CorrDist, pairwise

using Random: seed!

# ---- #

const DA = joinpath(Nucleus._DA, "GPSMap")

# ---- #

@test Nucleus.Path.read(DA) == ["grouping_x_sample_x_group.tsv", "h.tsv", "w.tsv"]

# ---- #

function cluster_plot(ht, ro_, co_, rc)

    ir_ = Nucleus.Clustering.hierarchize(CorrDist(), eachrow(rc)).order

    ic_ = Nucleus.Clustering.hierarchize(CorrDist(), eachcol(rc)).order

    Nucleus.Plot.plot_heat_map(ht, rc[ir_, ic_]; y = ro_[ir_], x = co_[ic_])

end

# ---- #

const _NF, NO_, PO_, H = Nucleus.DataFrame.separate(joinpath(DA, "h.tsv"))

cluster_plot(joinpath(Nucleus.TE, "h.html"), NO_, PO_, H)

# ---- #

foreach(Nucleus.Normalization.normalize_with_0!, eachrow(H))

clamp!(H, -3, 3)

foreach(Nucleus.Normalization.normalize_with_01!, eachrow(H))

cluster_plot(joinpath(Nucleus.TE, "h_normalized.html"), NO_, PO_, H)

# ---- #

const _ng, GR_, _po_, GP =
    Nucleus.DataFrame.separate(joinpath(DA, "grouping_x_sample_x_group.tsv"))

const LA_ = GP[findfirst(==("K15"), GR_), :] .+ 1

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "h_labeled.html"), H; y = NO_, x = PO_, gc_ = LA_)

# ---- #

const NN = pairwise(Nucleus.Distance.InformationDistance(), eachrow(H))

cluster_plot(joinpath(Nucleus.TE, "distance.html"), NO_, NO_, NN)

# ---- #

seed!(202312091501)

const CN = Nucleus.Coordinate.get_cartesian(NN)

# ---- #

seed!(202404241617)

const LN = Nucleus.Coordinate.convert_polar_to_cartesian(
    Nucleus.Coordinate.make_unit(Nucleus.Coordinate.get_polar(NN; pl = true)),
)

# ---- #

const NP = copy(H)

NP .^= 1.5

foreach(Nucleus.Normalization.normalize_with_sum!, eachcol(NP))

# ---- #

const CP = CN * NP

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "point_cartesian.html"),
    CP;
    y = ["Y", "X"],
    x = PO_,
    gc_ = LA_,
)

# ---- #

const LP = LN * NP

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "point_polar_cartesian.html"),
    LP;
    y = ["Y", "X"],
    x = PO_,
    gc_ = LA_,
)

# ---- #

const point_marker_size = 10

# ---- #

Nucleus.GPSMap.plot(joinpath(Nucleus.TE, "gps_map.html"), NO_, CN, PO_, CP; sc_ = LA_)

# ---- #

Nucleus.PolarGPSMap.plot(joinpath(Nucleus.TE, "polar_gps_map.html"), NO_, LN, PO_, LP;)

# ---- #

Nucleus.PolarGPSMap.plot(joinpath(Nucleus.TE, "polar_gps_map.html"), NO_, LN, PO_, LP; sc_ = LA_)
