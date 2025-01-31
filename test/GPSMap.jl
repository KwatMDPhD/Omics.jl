using Distances: CorrDist, pairwise

using Random: seed!

using Test: @test

using Omics

# ---- #

const DA = joinpath(pkgdir(Omics), "data", "GPSMap")

# ---- #

function cluster_plot(ht, ro_, co_, rc)

    ir_ = Omics.Clustering.hierarchize(pairwise(CorrDist(), eachrow(rc))).order

    ic_ = Omics.Clustering.hierarchize(pairwise(CorrDist(), eachcol(rc))).order

    Omics.Plot.plot_heat_map(ht, rc[ir_, ic_]; ro_ = ro_[ir_], co_ = co_[ic_])

end

# ---- #

ta = Omics.Table.rea(joinpath(DA, "h.tsv"))

const NO_ = ta[!, 1]

const PO_ = names(ta)[2:end]

const H = Matrix(ta[!, 2:end])

cluster_plot(joinpath(tempdir(), "h.html"), NO_, PO_, H)

# ---- #

foreach(Omics.Normalization.normalize_with_0!, eachrow(H))

clamp!(H, -3, 3)

foreach(Omics.Normalization.normalize_with_01!, eachrow(H))

cluster_plot(joinpath(tempdir(), "h_normalized.html"), NO_, PO_, H)

# ---- #

ta = Omics.Table.rea(joinpath(DA, "grouping_x_sample_x_group.tsv"))

const GR_ = ta[!, 1]

const GP = Matrix(ta[:, 2:end])

const LA_ = GP[findfirst(==("K15"), GR_), :] .+ 1

Omics.Plot.plot_heat_map(
    joinpath(tempdir(), "h_labeled.html"),
    H;
    ro_ = NO_,
    co_ = PO_,
    #gc_ = LA_,
)

# ---- #

const NN = pairwise(Omics.Distance.Information(), eachrow(H))

cluster_plot(joinpath(tempdir(), "distance.html"), NO_, NO_, NN)

# ---- #

seed!(202312091501)

const CN = Omics.Coordinate.get_cartesian(NN)

# ---- #

seed!(202404241617)

const LN = Omics.Coordinate.convert_polar_to_cartesian(
    Omics.Coordinate.make_unit(Omics.Coordinate.get_polar(NN; pl = true)),
)

# ---- #

const NP = copy(H)

NP .^= 1.5

foreach(Omics.Normalization.normalize_with_sum!, eachcol(NP))

# ---- #

const CP = CN * NP

Omics.Plot.plot_heat_map(
    joinpath(tempdir(), "point_cartesian.html"),
    CP;
    ro_ = ["Y", "X"],
    co_ = PO_,
    #gc_ = LA_,
)

# ---- #

const LP = LN * NP

Omics.Plot.plot_heat_map(
    joinpath(tempdir(), "point_polar_cartesian.html"),
    LP;
    ro_ = ["Y", "X"],
    co_ = PO_,
    #gc_ = LA_,
)

# ---- #

const point_marker_size = 10

# ---- #

Omics.GPSMap.plot(joinpath(tempdir(), "gps_map.html"), NO_, CN, PO_, CP; ta_ = LA_)

# ---- #

Omics.GPSMap.plot(joinpath(tempdir(), "polar_gps_map.html"), NO_, LN, PO_, LP)

# ---- #

Omics.GPSMap.plot(
    joinpath(tempdir(), "polar_gps_map.html"),
    NO_,
    LN,
    PO_,
    LP;
    ta_ = LA_,
    size = 1000,
    margin = 0.01,
)
