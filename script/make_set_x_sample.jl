using BioLab

# ---- #

if isinteractive()

    ARGS = split(
        "~/craft/data/sex/feature_x_sample_x_number.tsv ~/craft/data/gene_set 15 500 0.7 ~/Downloads/set_x_sample_x_enrichment",
    )

end

tsf, se, mis, mas, frs, ou = ARGS

tsf = expanduser(tsf)
@assert isfile(tsf)
@show tsf

se = expanduser(se)
@assert isdir(se)
@show se

mi = parse(Int, mis)
@show mi

ma = parse(Int, mas)
@show ma

fr = parse(Float64, frs)
@show fr

ou = expanduser(ou)
@assert isempty(readdir(ou))
@show ou

# ---- #

_naf, fe_, sa_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.Table.read(tsf))

replace!(fe_x_sa_x_nu, 0.0 => NaN)

# ---- #

al = BioLab.FeatureSetEnrichment.KS()

for ba in readdir(se)

    if !contains(ba, r"^(?!_).*json$")

        continue

    end

    na = split(ba, '.')[1]

    BioLab.print_header(na)

    se_fe1_ = BioLab.Dict.read(joinpath(se, ba))

    se_ = Vector{String}()

    fe1___ = Vector{Vector{String}}()

    for (se, fe1_) in se_fe1_

        n_ke = length(intersect(fe_, fe1_))

        if mi <= n_ke <= ma && fr <= n_ke / length(fe1_)

            push!(se_, se)

            push!(fe1___, fe1_)

        end

    end

    n_ke = length(se_)

    println("👍 Kept $n_ke/$(length(se_fe1_)) sets.")

    if n_ke == 0

        continue

    end

    sc_ = fe_x_sa_x_nu[:, 1]

    go_ = findall(!isnan, sc_)

    scg_, feg_ = BioLab.Collection.sort_like((sc_[go_], fe_[go_]); ic = false)

    BioLab.FeatureSetEnrichment.enrich(al, feg_, scg_, fe1___[1]; title_text = na)

    BioLab.Table.write(
        joinpath(ou, "$(na)_x_sample_x_enrichment.tsv"),
        BioLab.DataFrame.make(
            na,
            se_,
            sa_,
            BioLab.FeatureSetEnrichment.enrich(al, fe_, sa_, fe_x_sa_x_nu, se_, fe1___),
        ),
    )

end
