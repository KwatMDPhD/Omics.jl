using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

const DA = joinpath(Nucleus._DA, "GPSMap")

# ---- #

@test Nucleus.Path.read(DA) == ["grouping_x_sample_x_group.tsv", "h.tsv", "w.tsv"]

# ---- #

for di in (
    [
        0.0 1 1 1
        1 0 1 1
        1 1 0 1
        1 1 1 0
    ],
    [
        0.0 2 1 1
        2 0 1 1
        1 1 0 1
        1 1 1 0
    ],
    [
        0.0 1 2 1
        1 0 1 1
        2 1 0 1
        1 1 1 0
    ],
    [
        0.0 1 1 2
        1 0 1 1
        1 1 0 1
        2 1 1 0
    ],
    [
        0.0 2 2 1
        2 0 1 1
        2 1 0 1
        1 1 1 0
    ],
    [
        0.0 1 2 2
        1 0 1 1
        2 1 0 1
        2 1 1 0
    ],
    [
        0.0 2 1 2
        2 0 1 1
        1 1 0 1
        2 1 1 0
    ],
    [
        0.0 1 2 3
        1 0 1 1
        2 1 0 1
        3 1 1 0
    ],
)

    nn = 4

    np = 10

    no_ = (id -> "Node $id").(1:nn)

    po_ = (id -> "Point $id").(1:np)

    ci = ones(nn, np)

    for mu in (0.333, 1, 3)

        Nucleus.GPSMap.plot(
            "",
            no_,
            Nucleus.Coordinate.get(di * mu),
            po_,
            ci;
            layout = Dict(
                "title" =>
                    Dict("text" => "$(join(convert(Vector{Int},view(di, 1, :)), ' '))  *$mu"),
            ),
        )

    end

end

# ---- #

function get_distance(nu___)

    Nucleus.Distance.get_half(Nucleus.Information.get_information_coefficient_distance, nu___)

end

# ---- #

function order(nu___)

    Nucleus.Clustering.hierarchize(get_distance(nu___)).order

end

# ---- #

function cluster_plot(ht, ro_, co_, ma)

    i1_ = order(eachrow(ma))

    i2_ = order(eachcol(ma))

    Nucleus.Plot.plot_heat_map(ht, ma[i1_, i2_]; y = ro_[i1_], x = co_[i2_])

end

# ---- #

_nf, fa_, sa_, mh = Nucleus.DataFrame.separate(joinpath(DA, "h.tsv"))

cluster_plot(joinpath(Nucleus.TE, "h.html"), fa_, sa_, mh)

# ---- #

for ea in eachrow(mh)

    Nucleus.Normalization.normalize_with_0!(ea)

    clamp!(ea, -3, 3)

    Nucleus.Normalization.normalize_with_01!(ea)

end

cluster_plot(joinpath(Nucleus.TE, "h_normalized.html"), fa_, sa_, mh)

# ---- #

_ng, gr_, _sa_, la = Nucleus.DataFrame.separate(joinpath(DA, "grouping_x_sample_x_group.tsv"))

la_ = la[Nucleus.Collection.find("K15", gr_), :] .+ 1

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "h_labeled.html"), mh; y = fa_, x = sa_, gc_ = la_)

# ---- #

di = get_distance(eachrow(mh))

cluster_plot(joinpath(Nucleus.TE, "distance.html"), fa_, fa_, di)

# ---- #

seed!(202312091501)

const CN = Nucleus.Coordinate.get(di)

# ---- #

const KE_AR = (pu = 2, point_marker_size = 8)

# ---- #

Nucleus.GPSMap.plot(joinpath(Nucleus.TE, "map.html"), fa_, CN, sa_, mh; KE_AR...)

# ---- #

Nucleus.GPSMap.plot(
    joinpath(Nucleus.TE, "map_with_score.html"),
    fa_,
    CN,
    sa_,
    mh;
    sc_ = la_,
    KE_AR...,
)
