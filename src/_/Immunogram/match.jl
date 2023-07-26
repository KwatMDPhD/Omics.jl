include("_.jl")

# ---- #

if isinteractive()

    ARGS = "example.3", "true", "1", "-1", "1", "../input/data/vaccine_response_yfv.json"

end

it, as, de, pe, bo, da, nas, los_, tsi, iop, tsf, lof_ = parse_args()

# ---- #

ou = make_output_directory(@__FILE__, it, as, de, splitext(basename(da))[1])

# ---- #

js = include_ito(it)

# ---- #

_, io_, sa_, io_x_sa_x_an = BioLab.DataFrame.separate(BioLab.DataFrame.read(tsi))

ta_ = io_x_sa_x_an[findfirst(io == iop for io in io_), :]

ta_, ta_x_sa_x_nu = make_ta_x_sa_x_nu(ta_)

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

n_ta = length(ta_)

n_na = 4

na_ = Vector{String}(undef, n_na)

nac_ = Vector{String}(undef, n_na)

fu = BioLab.Match._get_pearson_correlation

ta_x_na_x_sc = Matrix{Float64}(undef, (n_ta, n_na))

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
        ht = joinpath(ou, "$na.html"),
    )

    for (idt, (ta, nu_)) in enumerate(zip(ta_, eachrow(ta_x_sa_x_nu)))

        feature_x_statistics_x_number = BioLab.Match.make(
            fu,
            ta,
            na,
            ro_,
            sa_,
            nu_,
            ro_x_co_x_nu;
            n_ma = 10,
            n_pv = 10,
            pl = bo,
            di = mkpath(joinpath(ou, "$ta.$na")),
        )

        ta_x_na_x_sc[idt, id] = average_match_score(feature_x_statistics_x_number)

    end

end

# ---- #

n = 100

ta_x_sh_x_sc = Matrix{Float64}(undef, (n_ta, n))

id = n_na

na_[id] = NAS

nac_[id] = COS

@showprogress for id in 1:n

    ro_x_co_x_nu = Kumo.anneal(no_x_sa_x_he, shuffle!(so_x_ta_x_ed); de, pr = false)

    for (idt, (ta, nu_)) in enumerate(zip(ta_, eachrow(ta_x_sa_x_nu)))

        feature_x_statistics_x_number = BioLab.Match.make(
            fu,
            ta,
            NAS,
            Kumo.NO_,
            sa_,
            nu_,
            ro_x_co_x_nu;
            pr = false,
            n_ma = 0,
            n_pv = 0,
            pl = false,
        )

        ta_x_sh_x_sc[idt, id] = average_match_score(feature_x_statistics_x_number)

    end

end

ta_x_na_x_sc[:, id] = mean(eachcol(ta_x_sh_x_sc))

# ---- #

so_ = sortperm(ta_x_na_x_sc[:, 1])

ta_ = ta_[so_]

ta_x_na_x_sc = ta_x_na_x_sc[so_, :]

# ---- #

ht = joinpath(ou, "summary.html")

BioLab.Plot.plot_bar(
    [collect(co) for co in eachcol(ta_x_na_x_sc)],
    fill(ta_, n_na);
    name_ = na_,
    marker_color_ = nac_,
    layout = Dict(
        "barmode" => "",
        "title" => Dict("text" => "Phenotype-Feature Correlations"),
        "yaxis" => Dict("title" => Dict("text" => "Mean of Correlation Magnitudes")),
        "xaxis" => Dict("title" => Dict("text" => "Phenotypes")),
    ),
    ht,
)

# ---- #

BioLab.Dict.write(
    BioLab.Path.replace_extension(ht, "json"),
    OrderedDict(zip(na_, mean(eachrow(abs.(ta_x_na_x_sc))))),
)
