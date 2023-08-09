module Database
# Test.

using StatsBase: median

using BioLab

function describe(information_x_sample_x_anything)

    for an_ in eachrow(information_x_sample_x_anything)

        la = an_[1]

        st = BioLab.Collection.count_sort_string(an_[2:end])

        @info "$la\n$st"

    end

end

# TODO: Generalize in Dict and use in GEO.tabulate.
function rename!(fe_, fe_fe2)

    n_re = 0

    for (id, fe) in enumerate(fe_)

        if haskey(fe_fe2, fe)

            fe_[id] = fe_fe2[fe]

            n_re += 1

        elseif startswith(fe, "ENS") && contains(fe, '.')

            fe = BioLab.String.split_get(fe, '.', 1)

            if haskey(fe_fe2, fe)

                fe_[id] = fe_fe2[fe]

                n_re += 1

            end

        end

    end

    n = length(fe_)

    @info "Renamed $n_re / $n."

end

function rename_collapse_log2_plot(di, fe_, fe_fe2, fe_x_sa_x_nu, lo, title_text)

    BioLab.Error.error_missing(di)

    BioLab.Error.error_bad(fe_x_sa_x_nu)

    BioLab.Plot.plot_histogram(
        joinpath(di, "number.html"),
        (vec(fe_x_sa_x_nu),);
        layout = Dict("title" => Dict("text" => "$title_text (raw)")),
    )

    if !isempty(fe_fe2)

        rename!(fe_, fe_fe2)

    end

    if !allunique(fe_)

        fe_, fe_x_sa_x_nu = BioLab.Matrix.collapse(median, Float64, fe_, fe_x_sa_x_nu)

    end

    if lo

        fe_x_sa_x_nu .= log2.(fe_x_sa_x_nu .+ 1)

        BioLab.Plot.plot_histogram(
            joinpath(di, "number_plus1_log2.html"),
            (vec(fe_x_sa_x_nu),),
            layout = Dict("title" => Dict("text" => "$title_text (+1 Log2)")),
        )

    end

    fe_, fe_x_sa_x_nu

end

function get_geo(
    di,
    gs;
    re = false,
    sa = "!Sample_title",
    se_ = (),
    res_ = (),
    rec_ = (),
    nas = "Sample",
    ur = "",
    fe_fe2 = Dict{String, String}(),
    lo = false,
    naf = "Gene",
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

    characteristic_x_sample_x_anything, pl_da = BioLab.GEO.tabulate(bl_th; sa)

    describe(characteristic_x_sample_x_anything)

    nac, ch_, sa_, ch_x_sa_x_an = BioLab.DataFrame.separate(characteristic_x_sample_x_anything)

    replace!(ch_x_sa_x_an, missing => "")

    si = size(ch_x_sa_x_an)

    @info "Characteristic size = $si."

    if !isempty(se_)

        is_ = (sa -> all(occursin(sa), se_)).(sa_)

        sa_ = view(sa_, is_)

        ch_x_sa_x_an = view(ch_x_sa_x_an, :, is_)

        si = size(ch_x_sa_x_an)

        @info "Characteristic size = $si."

    end

    if !isempty(res_)

        @info "Replacing sample strings"

        sa_ = replace.(sa_, res_...)

    end

    if !isempty(rec_)

        @info "Replacing characteristic values"

        ch_x_sa_x_an = replace.(ch_x_sa_x_an, rec_...)

    end

    nasc = BioLab.Path.clean(nas)

    BioLab.DataFrame.write(
        joinpath(ou, "characteristic_x_$(nasc)_x_anything.tsv"),
        BioLab.DataFrame.make(nac, ch_, sa_, ch_x_sa_x_an),
    )

    pl_ = collect(keys(pl_da))

    n_pl = length(pl_)

    if iszero(n_pl)

        if !endswith(ur, "gz")

            error("URL does not end with gz.")

        end

        gz = joinpath(ou, "$gs.tsv.gz")

        @info "$ur --> $gz"

        if !isfile(gz) || re

            download(ur, gz)

        end

        feature_x_sample_x_number = BioLab.DataFrame.read(gz)

    elseif isone(n_pl)

        feature_x_sample_x_number = pl_da[pl_[1]]

    elseif 1 < n_pl

        error("There are $n_nl platforms.")

    end

    _naf, fe_, sa2_, fe_x_sa2_x_nu = BioLab.DataFrame.separate(feature_x_sample_x_number)

    if !isempty(res_)

        sa2_ = replace.(sa2_, res_...)

    end

    if sa_ == sa2_

        fe_x_sa_x_nu = fe_x_sa2_x_nu

    else

        @warn "Samples differ. Matching to characteristic's"

        id_ = indexin(sa_, sa2_)

        sa2_ = view(sa2_, id_)

        fe_x_sa_x_nu = view(fe_x_sa2_x_nu, :, id_)

    end

    fe_, fe_x_sa_x_nu = rename_collapse_log2_plot(ou, fe_, fe_fe2, fe_x_sa_x_nu, lo, gs)

    nafc = BioLab.Path.clean(naf)

    pr = joinpath(ou, "$(nafc)_x_$(nasc)_x_number")

    BioLab.DataFrame.write("$pr.tsv", BioLab.DataFrame.make(naf, fe_, sa_, fe_x_sa_x_nu))

    title_text = gs

    if isempty(chg)

        grc_ = Vector{Int}()

    else

        grc_ = BioLab.String.try_parse.(view(ch_x_sa_x_an, findfirst(==(chg), ch_), :))

        title_text *= " Grouped by " * titlecase(chg)

    end

    BioLab.Plot.plot_heat_map(
        "$pr.html",
        fe_x_sa_x_nu,
        fe_,
        sa_;
        nar = naf,
        nac = nas,
        grc_,
        layout = Dict("title" => Dict("text" => title_text)),
    )

    ou, nas, sa_, nac, ch_, ch_x_sa_x_an, fe_, fe_x_sa_x_nu

end

end
