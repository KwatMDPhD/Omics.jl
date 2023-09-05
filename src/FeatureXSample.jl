module FeatureXSample

using StatsBase: median

using ..BioLab

function describe(information_x_sample_x_anything)

    for an_ in eachrow(information_x_sample_x_anything)

        @info "$(an_[1])\n$(BioLab.Collection.count_sort_string(an_[2:end]))"

    end

end

function error_rename_collapse_log2_plot(di, fe_, fe_x_sa_x_nu, fe_fe2, lo, title_text)

    BioLab.Error.error_missing(di)

    BioLab.Error.error_bad(fe_)

    BioLab.Error.error_bad(fe_x_sa_x_nu)

    BioLab.Plot.plot_histogram(
        joinpath(di, "number.html"),
        (vec(fe_x_sa_x_nu),);
        layout = Dict("title" => Dict("text" => title_text)),
    )

    if !isempty(fe_fe2)

        BioLab.Gene.rename!(fe_, fe_fe2)

    end

    if !allunique(fe_)

        fe_, fe_x_sa_x_nu = BioLab.Matrix.collapse(median, Float64, fe_, fe_x_sa_x_nu)

    end

    if lo

        fe_x_sa_x_nu .= log2.(fe_x_sa_x_nu .+ 1)

        BioLab.Plot.plot_histogram(
            joinpath(di, "number_plus1_log2.html"),
            (vec(fe_x_sa_x_nu),);
            layout = Dict("title" => Dict("text" => "$title_text (+1 Log2)")),
        )

    end

    fe_, fe_x_sa_x_nu

end

end
