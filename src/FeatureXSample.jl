module FeatureXSample

using Downloads: download

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

        @info "Log2ing"

        fe_x_sa_x_nu .= log2.(fe_x_sa_x_nu .+ 1)

        Nucleus.Plot.plot_histogram(
            joinpath(di, "number_plus1_log2.html"),
            (vec(fe_x_sa_x_nu),);
            layout = Dict("title" => Dict("text" => "$na (+1 Log2)")),
        )

    end

    fe_, fe_x_sa_x_nu

end

function _intersect(sa1_, sa2_, an_x_sa1_x_an, an_x_sa2_x_an)

    sa_ = intersect(sa1_, sa2_)

    n = lastindex(sa_)

    st = "Intersected samples. $(lastindex(sa1_)) ∩ $(lastindex(sa2_)) = $n."

    if iszero(n)

        error("$st.\n$sa1_.\n$sa2_.")

    end

    @info st

    sa_, an_x_sa1_x_an[:, indexin(sa_, sa1_)], an_x_sa2_x_an[:, indexin(sa_, sa2_)]

end

function get_geo(
    di,
    na,
    pl = "";
    re = false,
    ke = Nucleus.GEO.KE,
    sas_ = (),
    chr_ = (),
    ur = "",
    sar_ = (),
    fe_fe2 = Dict{String, String}(),
    lo = false,
    ch = "",
)

    Nucleus.Error.error_missing(di)

    ou = joinpath(di, lowercase(na))

    if !isdir(ou) || re

        Nucleus.Path.remake_directory(ou)

    end

    gz = joinpath(ou, "$(na)_family.soft.gz")

    if !isfile(gz) || re

        Nucleus.GEO.download(ou, na)

    end

    bl_th = Nucleus.GEO.read(gz)

    sa_ke_va = bl_th["SAMPLE"]

    sa_ = Nucleus.GEO.get_sample(sa_ke_va, ke)

    if !isempty(sas_)

        is_ = (ke -> all(occursin(ke), sas_)).(sa_)

        sa_ = sa_[is_]

        @info "Selected $(sum(is_)) / $(lastindex(is_)) samples."

    end

    ch_, ch_x_sa_x_an = Nucleus.GEO.tabulate(sa_ke_va)

    @info "Characteristic size = $(size(ch_x_sa_x_an))."

    count(ch_, eachrow(ch_x_sa_x_an))

    if !isempty(chr_)

        @info "Replacing characteristic strings"

        ch_x_sa_x_an = replace.(ch_x_sa_x_an, chr_...)

    end

    if isempty(ur)

        if isempty(pl)

            pl_ = collect(keys(bl_th["PLATFORM"]))

            if isone(lastindex(pl_))

                pl = pl_[1]

            else

                error("There is not one platform: $pl_.")

            end

        end

        fe_, saf_, fe_x_sa_x_nu = Nucleus.GEO.tabulate(bl_th["PLATFORM"][pl], sa_ke_va, ke)

    else

        gz = joinpath(ou, "$na.tsv.gz")

        if !isfile(gz) || re

            @info "$ur --> $gz"

            download(ur, gz)

        end

        _naf, fe_, saf_, fe_x_sa_x_nu = Nucleus.DataFrame.separate(gz)

    end

    if sa_ != saf_

        sa_, ch_x_sa_x_an, fe_x_sa_x_nu = _intersect(sa_, saf_, ch_x_sa_x_an, fe_x_sa_x_nu)

    end

    if !isempty(sar_)

        @info "Replacing sample strings"

        sa_ = replace.(sa_, sar_...)

    end

    fe_, fe_x_sa_x_nu = transform(ou, fe_, sa_, fe_x_sa_x_nu; fe_fe2, lo, na)

    Nucleus.DataFrame.write(
        joinpath(ou, "characteristic_x_sample_x_any.tsv"),
        "Characteristic",
        ch_,
        sa_,
        ch_x_sa_x_an,
    )

    pr = joinpath(ou, "feature_x_sample_x_number")

    Nucleus.DataFrame.write("$pr.tsv", pl, fe_, sa_, fe_x_sa_x_nu)

    if isempty(ch)

        grc_ = Int[]

        title_text = na

    else

        grc_ = ch_x_sa_x_an[findfirst(==(ch), ch_), :]

        title_text = "$na (by $(titlecase(ch)))"

    end

    Nucleus.Plot.plot_heat_map(
        "$pr.html",
        fe_x_sa_x_nu;
        y = fe_,
        x = sa_,
        nar = pl,
        nac = "Sample",
        grc_,
        layout = Dict("title" => Dict("text" => title_text)),
    )

    ou, sa_, ch_, ch_x_sa_x_an, fe_, fe_x_sa_x_nu

end

end
