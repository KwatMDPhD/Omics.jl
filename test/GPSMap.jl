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

    Nucleus.Clustering.hierarchize(
        Nucleus.Distance.get_half(Nucleus.Information.get_information_coefficient_distance, nu___),
    ).order

end

# ---- #

_naf, fa_, sa_, mh = Nucleus.DataFrame.separate(joinpath(DA, "h.tsv"))

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "h.html"), mh; y = fa_, x = sa_)

# ---- #

for co in eachcol(mh)

    Nucleus.Normalization.normalize_with_0!(co)

    clamp!(co, -3, 3)

    Nucleus.Normalization.normalize_with_01!(co)

end

id1_ = order(eachrow(mh))

id2_ = order(eachcol(mh))

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "h_normalized.html"),
    mh[id1_, id2_];
    y = fa_[id1_],
    x = sa_[id2_],
)

# ---- #

mh .^= 2

id1_ = order(eachrow(mh))

id2_ = order(eachcol(mh))

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "h_powered.html"),
    mh[id1_, id2_];
    y = fa_[id1_],
    x = sa_[id2_],
)

# ---- #

no_x_no_x_di = Nucleus.Distance.get_half(
    Nucleus.Information.get_information_coefficient_distance,
    eachrow(mh),
)

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "distance.html"), no_x_no_x_di; x = fa_, y = fa_)

# ---- #

seed!()

Nucleus.GPSMap._get_coordinate!(no_x_no_x_di, copy(mh))

# 160.375 μs (3261 allocations: 318.62 KiB)
#@btime Nucleus.GPSMap._get_coordinate!($no_x_no_x_di, co) setup =
#    (co = copy(mh); seed!(202312042237)) evals = 1;

# ---- #

seed!()

Nucleus.GPSMap.plot(joinpath(Nucleus.TE, "map.html"), fa_, sa_, copy(mh), no_x_no_x_di)

# ---- #

_nag, gr_, _sa_, gr_x_sa_x_la =
    Nucleus.DataFrame.separate(joinpath(DA, "grouping_x_sample_x_group.tsv"))
@assert sa_ == _sa_

la_ = gr_x_sa_x_la[findfirst(==("K15"), gr_), :] .+ 1

Nucleus.Plot.plot_heat_map(
    joinpath(Nucleus.TE, "h_labeled.html"),
    mh;
    y = fa_,
    x = sa_,
    grc_ = la_,
)

# ---- #

seed!(202312042237)

Nucleus.GPSMap.plot(joinpath(Nucleus.TE, "map_with_score.html"), fa_, sa_, mh, la_)
