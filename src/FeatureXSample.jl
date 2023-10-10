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

function get(
    di,
    gs;
    re = false,
    sa = "!Sample_title",
    # TODO: Consider selecting and replacing outside later.
    se_ = (),
    res_ = (),
    rec_ = (),
    ur = "",
    fe_fe2 = Dict{String, String}(),
    lo = false,
    chg = "",
)

    BioLab.Error.error_missing(di)

    ou = joinpath(di, BioLab.Path.clean(gs))

    gz = joinpath(ou, "$(gs)_family.soft.gz")

    if !isfile(gz) || re

        BioLab.Path.remake_directory(ou)

        BioLab.GEO.download(ou, gs)

    end

    bl_th = BioLab.GEO.read(gz)

    na_feature_x_sample_x_any = BioLab.GEO.tabulate(bl_th, sa)

    nac, ch_, sa_, ch_x_sa_x_st =
        BioLab.DataFrame.separate(pop!(na_feature_x_sample_x_any, "Characteristic"))

    BioLab.FeatureXSample.count(ch_, eachrow(ch_x_sa_x_st))

    replace!(ch_x_sa_x_st, missing => "")

    @info "Characteristic size = $(size(ch_x_sa_x_st))."

    if !isempty(se_)

        is_ = (sa -> all(occursin(sa), se_)).(sa_)

        sa_ = sa_[is_]

        ch_x_sa_x_st = ch_x_sa_x_st[:, is_]

        @info "Characteristic size = $(size(ch_x_sa_x_st))."

    end

    if !isempty(res_)

        @info "Replacing sample strings"

        sa_ = replace.(sa_, res_...)

    end

    if !isempty(rec_)

        @info "Replacing characteristic values"

        ch_x_sa_x_st = replace.(ch_x_sa_x_st, rec_...)

    end

    nas = "Sample"

    nasc = BioLab.Path.clean(nas)

    BioLab.DataFrame.write(
        joinpath(ou, "characteristic_x_$(nasc)_x_string.tsv"),
        BioLab.DataFrame.make(nac, ch_, sa_, ch_x_sa_x_st),
    )

    pl_ = collect(keys(na_feature_x_sample_x_any))

    n_pl = length(pl_)

    if iszero(n_pl)

        if !endswith(ur, "gz")

            error("$ur is not a `gz`.")

        end

        gz = joinpath(ou, "$gs.tsv.gz")

        @info "$ur --> $gz"

        if !isfile(gz) || re

            download(ur, gz)

        end

        feature_x_sample_x_float = BioLab.DataFrame.read(gz)

    elseif isone(n_pl)

        feature_x_sample_x_float = na_feature_x_sample_x_any[pl_[1]]

    elseif 1 < n_pl

        error("There are $n_pl platforms.")

    end

    naf, fe_, sa2_, fe_x_sa2_x_nu = BioLab.DataFrame.separate(feature_x_sample_x_float)

    nafc = BioLab.Path.clean(naf)

    if !isempty(res_)

        sa2_ = replace.(sa2_, res_...)

    end

    if sa_ == sa2_

        fe_x_sa_x_nu = fe_x_sa2_x_nu

    else

        @warn "Samples differ. Matching to characteristic's"

        id_ = indexin(sa_, sa2_)

        #sa2_ = sa2_[id_]

        fe_x_sa_x_nu = fe_x_sa2_x_nu[:, id_]

    end

    fe_, fe_x_sa_x_nu =
        BioLab.FeatureXSample.transform(ou, fe_, sa_, fe_x_sa_x_nu; fe_fe2, lo, na = gs)

    pr = joinpath(ou, "$(nafc)_x_$(nasc)_x_number")

    BioLab.DataFrame.write("$pr.tsv", BioLab.DataFrame.make(naf, fe_, sa_, fe_x_sa_x_nu))

    if isempty(chg)

        grc_ = Vector{Int}()

        title_text = gs

    else

        # TODO: Benchmark `view`.
        grc_ = BioLab.String.try_parse.(ch_x_sa_x_st[findfirst(==(chg), ch_), :])

        title_text = "$gs (by $(titlecase(chg)))"

    end

    BioLab.Plot.plot_heat_map(
        "$pr.html",
        fe_x_sa_x_nu;
        y = fe_,
        x = sa_,
        nar = naf,
        nac = nas,
        grc_,
        layout = Dict("title" => Dict("text" => title_text)),
    )

    ou, nas, sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_nu

end

end
