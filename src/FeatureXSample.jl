module FeatureXSample

using StatsBase: median

using ..Nucleus

function count(na_, an___)

    for (na, an_) in zip(na_, an___)

        @info "$na\n$(Nucleus.Collection.count_sort_string(an_))"

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
    na = "Data",
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

    Nucleus.Error.error_bad(isnan, fe_x_sa_x_nu)

    Nucleus.Error.error_bad(isinf, fe_x_sa_x_nu)

    layout = Dict("title" => Dict("text" => na))

    Nucleus.Plot.plot_heat_map(
        joinpath(di, "feature_x_sample_x_number.html"),
        fe_x_sa_x_nu;
        y = fe_,
        x = sa_,
        nar = "Feature",
        nac = "Sample",
        layout,
    )

    Nucleus.Plot.plot_histogram(joinpath(di, "number.html"), (vec(fe_x_sa_x_nu),); layout)

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
            joinpath(di, "number_plus1_log2.html"),
            (vec(fe_x_sa_x_nu),);
            layout = Dict("title" => Dict("text" => "$na (+1 Log2)")),
        )

    end

    fe_, fe_x_sa_x_nu

end

end
