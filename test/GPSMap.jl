using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

const DA = joinpath(Nucleus._DA, "GPSMap")

# ---- #

@test Nucleus.Path.read(DA) == ["grouping_x_sample_x_group.tsv", "h.tsv", "w.tsv"]

# ---- #

function order(nu___)

    Nucleus.Clustering.hierarchize(Nucleus.Distance.get(Nucleus.Distance.Euclidean(), nu___)).order

end

# ---- #

function plot(ht, ro_, co_, ma)

    id1_ = order(eachrow(ma))

    id2_ = order(eachcol(ma))

    Nucleus.Plot.plot_heat_map(ht, ma[id1_, id2_]; y = ro_[id1_], x = co_[id2_])

end

# ---- #

_naf, fa_, sa_, mh = Nucleus.DataFrame.separate(joinpath(DA, "h.tsv"))

plot(joinpath(Nucleus.TE, "h.html"), fa_, sa_, mh)

# ---- #

for co in eachcol(mh)

    Nucleus.Normalization.normalize_with_0!(co)

    clamp!(co, -3, 3)

    Nucleus.Normalization.normalize_with_01!(co)

end

plot(joinpath(Nucleus.TE, "h_normalized.html"), fa_, sa_, mh)

# ---- #

mh .^= 2

plot(joinpath(Nucleus.TE, "h_powered.html"), fa_, sa_, mh)

# ---- #

_nag, gr_, _sa_, gr_x_sa_x_la =
    Nucleus.DataFrame.separate(joinpath(DA, "grouping_x_sample_x_group.tsv"))

la_ = gr_x_sa_x_la[findfirst(==("K15"), gr_), :] .+ 1

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "h_labeled.html"),
    mh;
    y = fa_,
    x = sa_,
    grc_ = la_,
)

# ---- #

no_x_po_x_pu = mh

# ---- #

no_x_no_x_di = Nucleus.Distance.get(
    Nucleus.Distance.Euclidean(),
    #Nucleus.Information.get_information_coefficient_distance,
    eachrow(no_x_po_x_pu),
)

plot(joinpath(Nucleus.TE, "distance.html"), fa_, fa_, no_x_no_x_di)

# ---- #

const SE = 20231211

# ---- #

seed!(SE)

Nucleus.GPSMap.plot(joinpath(Nucleus.TE, "map.html"), fa_, no_x_no_x_di, sa_, no_x_po_x_pu)

# ---- #

seed!(SE)

Nucleus.GPSMap.plot(
    joinpath(Nucleus.TE, "map_with_label.html"),
    fa_,
    no_x_no_x_di,
    sa_,
    no_x_po_x_pu;
    la_,
)

# ---- #

seed!(SE)

Nucleus.GPSMap.plot(
    joinpath(Nucleus.TE, "map_with_score.html"),
    fa_,
    no_x_no_x_di,
    sa_,
    no_x_po_x_pu;
    la_,
    sc_ = la_,
)
