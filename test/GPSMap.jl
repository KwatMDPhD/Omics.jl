using Test: @test

using Nucleus

# ---- #

using Random: seed!

# ---- #

const DA = joinpath(Nucleus._DA, "GPSMap")

# ---- #

@test Nucleus.Path.read(DA) == ["grouping_x_sample_x_group.tsv", "h.tsv", "w.tsv"]

# ---- #

for (na1, no_x_no_x_di) in (
    (
        "111",
        [
            0 1 1 1
            1 0 1 1
            1 1 0 1
            1 1 1 0
        ],
    ),
    (
        "211",
        [
            0 2 1 1
            2 0 1 1
            1 1 0 1
            1 1 1 0
        ],
    ),
    (
        "121",
        [
            0 1 2 1
            1 0 1 1
            2 1 0 1
            1 1 1 0
        ],
    ),
    (
        "112",
        [
            0 1 1 2
            1 0 1 1
            1 1 0 1
            2 1 1 0
        ],
    ),
    (
        "221",
        [
            0 2 2 1
            2 0 1 1
            2 1 0 1
            1 1 1 0
        ],
    ),
    (
        "122",
        [
            0 1 2 2
            1 0 1 1
            2 1 0 1
            2 1 1 0
        ],
    ),
    (
        "212",
        [
            0 2 1 2
            2 0 1 1
            1 1 0 1
            2 1 1 0
        ],
    ),
    (
        "123",
        [
            0 1 2 3
            1 0 1 1
            2 1 0 1
            3 1 1 0
        ],
    ),
)

    no_ = (id -> "Node $id").(1:size(no_x_no_x_di, 1))

    po_ = (id -> "Point $id").(1:10)

    no_x_po_x_pu = ones(lastindex(no_), lastindex(po_))

    for (na2, no_x_no_x_di2) in
        (("10", no_x_no_x_di .* 10), ("1", no_x_no_x_di), ("0.1", no_x_no_x_di .* 0.1))

        Nucleus.GPSMap.plot(
            "",
            no_,
            no_x_no_x_di2,
            po_,
            no_x_po_x_pu;
            layout = Dict("title" => Dict("text" => "$na1 $na2")),
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

    id1_ = order(eachrow(ma))

    id2_ = order(eachcol(ma))

    Nucleus.Plot.plot_heat_map(ht, ma[id1_, id2_]; y = ro_[id1_], x = co_[id2_])

end

# ---- #

_naf, fa_, sa_, mh = Nucleus.DataFrame.separate(joinpath(DA, "h.tsv"))

cluster_plot(joinpath(Nucleus.TE, "h.html"), fa_, sa_, mh)

# ---- #

for co in eachcol(mh)

    Nucleus.Normalization.normalize_with_0!(co)

    clamp!(co, -3, 3)

    Nucleus.Normalization.normalize_with_01!(co)

end

cluster_plot(joinpath(Nucleus.TE, "h_normalized.html"), fa_, sa_, mh)

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

no_x_no_x_di = get_distance(eachrow(no_x_po_x_pu))

cluster_plot(joinpath(Nucleus.TE, "distance.html"), fa_, fa_, no_x_no_x_di)

# ---- #

const SE = 202312091501

# ---- #

const KE_AR = (pu = 2, point_marker_size = 13)

# ---- #

seed!(SE)

Nucleus.GPSMap.plot(
    joinpath(Nucleus.TE, "map.html"),
    fa_,
    no_x_no_x_di,
    sa_,
    no_x_po_x_pu;
    KE_AR...,
)

# ---- #

seed!(SE)

Nucleus.GPSMap.plot(
    joinpath(Nucleus.TE, "map_with_score.html"),
    fa_,
    no_x_no_x_di,
    sa_,
    no_x_po_x_pu;
    sc_ = la_,
    KE_AR...,
)
