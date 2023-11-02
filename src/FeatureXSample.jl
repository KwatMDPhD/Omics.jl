module FeatureXSample

using Downloads: download

using StatsBase: median

using ..Nucleus

function count(na_, an___)

    for (na, an_) in zip(na_, an___)

        println("🔦 $na\n$(Nucleus.Collection.count_sort_string(an_))")

    end

end

function transform(
    di,
    fe_,
    sa_,
    fe_x_sa_x_nu;
    fe_fe2 = Dict{String, String}(),
    fu = median,
    ty = Float64,
    lo = false,
    naf = "Feature",
    nas = "Sample",
    nan = "Number",
)

    Nucleus.Error.error_missing(di)

    Nucleus.Error.error_bad(isnothing, fe_)

    Nucleus.Error.error_bad(ismissing, fe_)

    Nucleus.Error.error_bad(Nucleus.String.is_bad, fe_)

    Nucleus.Error.error_duplicate(sa_)

    Nucleus.Error.error_bad(isnothing, sa_)

    Nucleus.Error.error_bad(ismissing, sa_)

    Nucleus.Error.error_bad(Nucleus.String.is_bad, sa_)

    Nucleus.Error.error_bad(isnothing, fe_x_sa_x_nu)

    Nucleus.Error.error_bad(ismissing, fe_x_sa_x_nu)

    Nucleus.Error.error_bad(!isfinite, fe_x_sa_x_nu)

    nafc = Nucleus.Path.clean(naf)

    nasc = Nucleus.Path.clean(nas)

    nanc = Nucleus.Path.clean(nan)

    layout = Dict("title" => Dict("text" => nan))

    Nucleus.Plot.plot_heat_map(
        joinpath(di, "$(nafc)_x_$(nasc)_x_$(nanc).html"),
        fe_x_sa_x_nu;
        y = fe_,
        x = sa_,
        nar = naf,
        nac = nas,
        layout,
    )

    na = "$(nafc)$(nasc)$(nanc)"

    Nucleus.Plot.plot_histogram(joinpath(di, "$na.html"), (vec(fe_x_sa_x_nu),); layout)

    if !isempty(fe_fe2)

        # TODO: Generalize the "ENSG" logic.
        Nucleus.Gene.rename!(fe_, fe_fe2)

    end

    if !allunique(fe_)

        fe_, fe_x_sa_x_nu = Nucleus.Matrix.collapse(fu, ty, fe_, fe_x_sa_x_nu)

    end

    if lo

        fe_x_sa_x_nu .= log2.(fe_x_sa_x_nu .+ 1)

        Nucleus.Plot.plot_histogram(
            joinpath(di, "$(na)_plus1_log2.html"),
            (vec(fe_x_sa_x_nu),);
            layout = Dict("title" => Dict("text" => "$nan (+1 Log2)")),
        )

    end

    fe_, fe_x_sa_x_nu

end

function _intersect(co1_, co2_, ro_x_co1_x_an, ro_x_co2_x_an)

    co_ = intersect(co1_, co2_)

    n = lastindex(co_)

    st = "$(lastindex(co1_)) ∩ $(lastindex(co2_)) = $n."

    if iszero(n)

        error(st)

    end

    @info "🪞 $st" co_

    co_, ro_x_co1_x_an[:, indexin(co_, co1_)], ro_x_co2_x_an[:, indexin(co_, co2_)]

end

function get_geo(
    di,
    gs,
    pl = "";
    ke = Nucleus.GEO.KE,
    ur = "",
    sas_ = (),
    sar_ = (),
    chr_ = (),
    fe_fe2 = Dict{String, String}(),
    lo = false,
    ch = "",
    nas = "Sample",
)

    Nucleus.Error.error_missing(di)

    di = joinpath(di, lowercase(gs))

    if !isdir(di)

        mkdir(di)

    end

    gz = joinpath(di, "$(gs)_family.soft.gz")

    if !isfile(gz)

        Nucleus.GEO.download(di, gs)

    end

    bl_th = Nucleus.GEO.read(gz)

    sa_ke_va = bl_th["SAMPLE"]

    sa_ = Nucleus.GEO.get_sample(sa_ke_va, ke)

    @info "👯‍♀️ Sample" sa_

    ch_, ch_x_sa_x_st = Nucleus.GEO.tabulate(sa_ke_va)

    @info "👙 Characteristic" ch_ ch_x_sa_x_st

    if isempty(ur)

        if isempty(pl)

            pl_ = collect(keys(bl_th["PLATFORM"]))

            if !isone(lastindex(pl_))

                error("There is not one platform. $pl_.")

            end

            pl = pl_[1]

        end

        fe_, saf_, fe_x_sa_x_nu = Nucleus.GEO.tabulate(bl_th["PLATFORM"][pl], sa_ke_va, ke)

    else

        gz = joinpath(di, "$gs.tsv.gz")

        if !isfile(gz)

            download(ur, gz)

        end

        pl = "Feature"

        _naf, fe_, saf_, fe_x_sa_x_nu = Nucleus.DataFrame.separate(gz)

    end

    @info "🧬 Feature" fe_ saf_ fe_x_sa_x_nu

    if sa_ != saf_

        sa_, ch_x_sa_x_st, fe_x_sa_x_nu = _intersect(sa_, saf_, ch_x_sa_x_st, fe_x_sa_x_nu)

    end

    if !isempty(sas_)

        is_ = (sa -> all(occursin(sa), sas_)).(sa_)

        sa_ = sa_[is_]

        ch_x_sa_x_st = ch_x_sa_x_st[:, is_]

        fe_x_sa_x_nu = fe_x_sa_x_nu[:, is_]

        @info "🏩 Selected sample" sa_

    end

    if !isempty(sar_)

        sa_ = replace.(sa_, sar_...)

    end

    if !isempty(chr_)

        replace!(ch_x_sa_x_st, chr_...)

    end

    fe_, fe_x_sa_x_nu = transform(di, fe_, sa_, fe_x_sa_x_nu; fe_fe2, lo, naf = pl, nas)

    nasc = Nucleus.Path.clean(nas)

    Nucleus.DataFrame.write(
        joinpath(di, "characteristic_x_$(nasc)_x_string.tsv"),
        "Characteristic",
        ch_,
        sa_,
        ch_x_sa_x_st,
    )

    count(ch_, eachrow(ch_x_sa_x_st))

    pr = joinpath(di, "$(lowercase(pl))_x_$(nasc)_x_number")

    Nucleus.DataFrame.write("$pr.tsv", pl, fe_, sa_, fe_x_sa_x_nu)

    if isempty(ch)

        grc_ = Int[]

        title_text = gs

    else

        grc_ = ch_x_sa_x_st[findfirst(==(ch), ch_), :]

        title_text = "$gs (by $(titlecase(ch)))"

    end

    Nucleus.Plot.plot_heat_map(
        "$pr.html",
        fe_x_sa_x_nu;
        y = fe_,
        x = sa_,
        nar = pl,
        nac = nas,
        grc_,
        layout = Dict("title" => Dict("text" => title_text)),
    )

    di, sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_nu

end

end
