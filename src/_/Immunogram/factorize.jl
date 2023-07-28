include("_.jl")

# ---- #

if isinteractive()

    ARGS = "example.3", "true", "1", "-1", "1", "../input/data/vaccine_response_yfv.json"
    ARGS = "ImmuneSystem", "true", "1", "-1", "0", "../input/data/sdy1264.0.json"

end

it, as, de, pe, bo, da, nas, los_, tsi, iop, tsf, lof_ = parse_args()

# ---- #

ou = make_output_directory(@__FILE__, it, as, de, splitext(basename(da))[1])

# ---- #

js = include_ito(it)

# ---- #

_, io_, sa_, io_x_sa_x_an = BioLab.DataFrame.separate(BioLab.DataFrame.read(tsi))

# ---- #

_naf, fe_, sa2_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.DataFrame.read(tsf))

@test allunique(fe_)

@test sa_ == sa2_

look(vec(fe_x_sa_x_nu))

# ---- #

ke_ = [!allequal(nu_) for nu_ in eachrow(fe_x_sa_x_nu)]

if !all(ke_)

    println("🫴 Keeping $(sum(ke_)) / $(length(ke_))")

    fe_ = fe_[ke_]

    fe_x_sa_x_nu = fe_x_sa_x_nu[ke_, :]

end

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

    ous = mkdir(joinpath(ou, sa))

    id = findfirst(sa2 == sa for sa2 in sa_)

    println("👽 $sa ($id)")

    println(join(view(io_x_sa_x_an, :, id), " | "))

    he_ = no_x_sa_x_he[:, id]

    # Kumo._get_norm(he_, true)

    if 0 <= pe

        Kumo.animate(js, Kumo.anneal(he_, so_x_ta_x_ed; de, pr = false), ous; pe, st_ = ST_)

    end

    # Kumo._get_norm(no_x_sa_x_an[:, id], true)

end

# ---- #

no_x_sa_x_po = [abs(an) for an in no_x_sa_x_an]

n_ = 3:5

fu = BioLab.MatrixFactorization._do_not_normalize
#fu = BioLab.Normalization.normalize_with_0!

nac = "Factor"

# ---- #

for n in n_

    println("🧇 $n")

    di = mkdir(joinpath(ou, "$nac.$n"))

    fa_ = ["$nac $id" for id in 1:n]

    no_x_fa_x_po, fa_x_sa_x_po = BioLab.MatrixFactorization.factorize(
        no_x_sa_x_po,
        n;
        fu,
        nar_ = (NAA,),
        nac_ = (sa_,),
        naf = nac,
        ro___ = (Kumo.NO_,),
        co___ = (sa_,),
        di,
    )

    nof_ = [argmax(ro) for ro in eachrow(no_x_fa_x_po)]

    saf_ = [argmax(co) for co in eachcol(fa_x_sa_x_po)]

    for id in eachindex(fa_)

        if fu == BioLab.MatrixFactorization._do_not_normalize

            he_ = no_x_fa_x_po[:, id]

        elseif fu == BioLab.Normalization.normalize_with_0!

            he_ = [convert(Float64, fa == id) for fa in nof_]

        end

        if bo

            Kumo.plot(; js, st_ = ST_, he_, ht = joinpath(di, "$n.$id.heat.html"))

        end

    end

    BioLab.Plot.plot_radar(
        fill(fa_, length(los_)),
        [fa_x_sa_x_po[:, id] for id in indexin(los_, sa_)];
        name_ = los_,
        ht = joinpath(di, "$n.radar.html"),
    )

end
