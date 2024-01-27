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

    no_ = (i1 -> "Node $i1").(1:nn)

    po_ = (i1 -> "Point $i1").(1:np)

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

function order(ea_)

    Nucleus.Clustering.hierarchize(Nucleus.GPSMap.distance(ea_)).order

end

# ---- #

function cluster_plot(ht, ro_, co_, nu)

    i1_ = order(eachrow(nu))

    i2_ = order(eachcol(nu))

    Nucleus.Plot.plot_heat_map(ht, nu[i1_, i2_]; y = ro_[i1_], x = co_[i2_])

end

# ---- #

_nf, fa_, sa_, mh = Nucleus.DataFrame.separate(joinpath(DA, "h.tsv"))

cluster_plot(joinpath(Nucleus.TE, "h.html"), fa_, sa_, mh)

# ---- #

const NU = [
    -9.0 -8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 8 9
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
]

# ---- #

for (ke_ar, re) in (
    (
        (),
        [
                    0.0 0.05022355489119638 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.9497764451088037 1.0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        ],
    ),
    (
        (lo = -Inf,),
        [
                    0.0 0.05588681851596242 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.5029813666436618 0.9500759147713611 1.0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        ],
    ),
    (
        (hi = Inf,),
        [
                    0.0 0.04992408522863893 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.4970186333563382 0.9441131814840377 1.0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        ],
    ),
    (
        (lo = -2, hi = 2),
        [
            0.0 0.0 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 0.5 1.0 1.0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
            0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        ],
    ),
)

    nu = copy(NU)

    ea_ = eachrow(nu)

    Nucleus.GPSMap.normalize_with_0_clamp_01!(ea_; ke_ar...)

    @test isapprox(nu, re; atol = 1e-5)

    # 526.974 ns (2 allocations: 160 bytes)
    # 526.753 ns (2 allocations: 160 bytes)
    # 526.832 ns (2 allocations: 160 bytes)
    # 527.272 ns (2 allocations: 160 bytes)
    #@btime Nucleus.GPSMap.normalize_with_0_clamp_01!($ea_)

end

# ---- #

const EA_ = eachrow(mh)

Nucleus.GPSMap.normalize_with_0_clamp_01!(EA_)

cluster_plot(joinpath(Nucleus.TE, "h_normalized.html"), fa_, sa_, mh)

# 45.333 μs (2 allocations: 256 bytes)
#@btime Nucleus.GPSMap.normalize_with_0_clamp_01!($EA_);

# ---- #

_ng, gr_, _sa_, la = Nucleus.DataFrame.separate(joinpath(DA, "grouping_x_sample_x_group.tsv"))

la_ = la[Nucleus.Collection.find("K15", gr_), :] .+ 1

Nucleus.Plot.plot_heat_map(joinpath(Nucleus.TE, "h_labeled.html"), mh; y = fa_, x = sa_, gc_ = la_)

# ---- #

@test isapprox(
    Nucleus.GPSMap.distance(eachrow([
        -1 0 1
        -2 0 2
        -1 0 2
        -2 0 1
    ])),
    [
        0.0        0.0285955  0.0285955  0.0285955
        0.0285955  0.0        0.0285955  0.0285955
        0.0285955  0.0285955  0.0        0.0285955
        0.0285955  0.0285955  0.0285955  0.0
    ];
    atol = 1e-7,
)

# ---- #

const DI = Nucleus.GPSMap.distance(eachrow(mh))

cluster_plot(joinpath(Nucleus.TE, "distance.html"), fa_, fa_, DI)

# ---- #

seed!(202312091501)

const CN = Nucleus.Coordinate.get(DI)

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
    sc_na = Dict(i1 => "State $i1" for i1 in 1:15),
    KE_AR...,
)
