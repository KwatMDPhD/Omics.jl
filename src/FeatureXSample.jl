module FeatureXSample

using StatsBase: median

using ..BioLab

function count(na_, an___)

    for (na, an_) in zip(na_, an___)

        @info "$na\n$(BioLab.Collection.count_sort_string(an_))"

    end

end

# TODO
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

    BioLab.Error.error_missing(di)

    BioLab.Error.error_bad(fe_)

    BioLab.Error.error_bad(sa_)

    BioLab.Error.error_duplicate(sa_)

    BioLab.Error.error_bad(fe_x_sa_x_nu)

    BioLab.Plot.plot_heat_map(
        joinpath(di, "feature_x_sample_x_number.html"),
        fe_x_sa_x_nu;
        y = fe_,
        x = sa_,
        nar = "Feature",
        nac = "Sample",
        layout = Dict("title" => Dict("text" => na)),
    )

    BioLab.Plot.plot_histogram(
        joinpath(di, "number.html"),
        (vec(fe_x_sa_x_nu),);
        layout = Dict("title" => Dict("text" => na)),
    )

    if !isempty(fe_fe2)

        # TODO: Generalize the "ENSG" logic.
        BioLab.Gene.rename!(fe_, fe_fe2)

    end

    if !allunique(fe_)

        fe_, fe_x_sa_x_nu = BioLab.Matrix.collapse(fu, ty, fe_, fe_x_sa_x_nu)

    end

    if lo

        fe_x_sa_x_nu .= log2.(fe_x_sa_x_nu .+ 1)

        BioLab.Plot.plot_histogram(
            joinpath(di, "number_plus1_log2.html"),
            (vec(fe_x_sa_x_nu),);
            layout = Dict("title" => Dict("text" => "$na (+1 Log2)")),
        )

    end

    fe_, fe_x_sa_x_nu

end

end
