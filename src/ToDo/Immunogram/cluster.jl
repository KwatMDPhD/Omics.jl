include("_.jl")

# ---- #

if isinteractive()

    ARGS = "example.3", "true", "1", "-1", "1", "../input/data/vaccine_response_yfv.json"
    ARGS = "ImmuneSystem", "true", "1", "-1", "1", "../input/data/gse107011.json"

end

it, as, de, pe, bo, da, nas, los_, tsi, iop, tsf, lof_ = parse_args()

# ---- #

ou = make_output_directory(@__FILE__, it, as, de, splitext(basename(da))[1])

# ---- #

js = include_ito(it)

# ---- #

_, io_, sa_, io_x_sa_x_an = BioLab.DataFrame.separate(BioLab.Table.read(tsi))

ta_ = io_x_sa_x_an[findfirst(io == iop for io in io_), :]

# ---- #

_naf, fe_, sa2_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tsf))

look(vec(fe_x_sa_x_nu))

# ---- #

ke_ = [!allequal(nu_) for nu_ in eachrow(fe_x_sa_x_nu)]

if !all(ke_)

    println("🫴 Keeping $(sum(ke_)) / $(length(ke_))")

    fe_ = fe_[ke_]

    fe_x_sa_x_nu = fe_x_sa_x_nu[ke_, :]

end

# ---- #

# TODO: Understand the effect of normalization.

BioLab.Matrix.apply_by_row!(BioLab.Normalization.normalize_with_0!, fe_x_sa_x_nu)

fe_x_sa_x_nu .-= minimum(fe_x_sa_x_nu) - 2.0

look(vec(fe_x_sa_x_nu))

# ---- #

BioLab.Plot.plot_histogram(
    [view(fe_x_sa_x_nu, id, :) for id in indexin(lof_, fe_)],
    fill(sa_, length(lof_));
    name_ = lof_,
)

# ---- #

if as

    fu = no -> no == "Antigen" || is_cell(no)

else

    fu = no -> false

end

no_x_sa_x_he = heat(fe_, fe_x_sa_x_nu, fu)

# ---- #

so_x_ta_x_ed = Kumo.make_edge_matrix()

no_x_sa_x_an = Kumo.anneal(no_x_sa_x_he, so_x_ta_x_ed; de, pr = false)

# ---- #

for sa in los_

    ous = mkpath(joinpath(ou, sa))

    id = findfirst(sa2 == sa for sa2 in sa_)

    BioLab.print_header("$sa ($id)")

    println(join(view(io_x_sa_x_an, :, id), " | "))

    he_ = no_x_sa_x_he[:, id]

    Kumo._get_norm(he_, true)

    if 0 <= pe

        Kumo.animate(js, Kumo.anneal(he_, so_x_ta_x_ed; de, pr = false), ous; pe, st_ = ST_)

    end

    Kumo._get_norm(no_x_sa_x_an[:, id], true)

end

# ---- #

n_na = 4

na_ = Vector{String}(undef, n_na)

nac_ = Vector{String}(undef, n_na)

fu = BioLab.Clustering.Euclidean()

sc_ = Vector{Float64}(undef, n_na)

# ---- #

for (id, (na, nac, ro_, ro_x_co_x_nu)) in enumerate((
    (NAF, COF, fe_, fe_x_sa_x_nu),
    (NAH, COH, Kumo.NO_, no_x_sa_x_he),
    (NAA, COA, Kumo.NO_, no_x_sa_x_an),
))

    na_[id] = na

    nac_[id] = nac

    BioLab.Plot.plot_heat_map(
        ro_x_co_x_nu,
        ro_,
        sa_;
        nar = na,
        nac = nas,
        grc_ = ta_,
        ht = joinpath(ou, "$na.html"),
    )

    sc_[id] = compare_grouping(ro_x_co_x_nu, ta_, fu; na, ou)

end

# ---- #

n = 100

scs_ = Vector{Float64}(undef, n)

id = n_na

na_[id] = NAS

nac_[id] = COS

@showprogress for id in 1:n

    scs_[id] = compare_grouping(
        Kumo.anneal(no_x_sa_x_he, shuffle!(so_x_ta_x_ed); de, pr = false),
        ta_,
        fu;
        pl = false,
    )

end

sc_[id] = mean(scs_)

# ---- #

sc_ *= 100

# ---- #

BioLab.Plot.plot_histogram(
    (scs_,);
    marker_color_ = (COS,),
    layout = Dict(
        "title" =>
            Dict("text" => "$(BioLab.Number.format(sc_[id]))% Tight Grouping Using $n Shufflings"),
    ),
    ht = joinpath(ou, "shuffling.html"),
)

# ---- #

BioLab.Dict.write(joinpath(ou, "summary.json"), OrderedDict(zip(na_, sc_)))
