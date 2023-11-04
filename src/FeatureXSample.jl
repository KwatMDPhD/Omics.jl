module FeatureXSample

using Downloads: download

using StatsBase: median

using ..Nucleus

function summarize(na_, an___)

    for (na, an_) in zip(na_, an___)

        println("🔦 $na\n$(Nucleus.Collection.count_sort_string(an_))")

    end

end

function match(co1_, co2_, ro_x_co1_x_an, ro_x_co2_x_an)

    co_ = intersect(co1_, co2_)

    n = lastindex(co_)

    if iszero(n)

        error("0.")

    end

    @info "🪞 $(lastindex(co1_)) ∩ $(lastindex(co2_)) = $n." co_

    co_, ro_x_co1_x_an[:, indexin(co_, co1_)], ro_x_co2_x_an[:, indexin(co_, co2_)]

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

end
