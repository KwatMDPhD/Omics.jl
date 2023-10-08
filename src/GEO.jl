module GEO

using DataFrames: DataFrame

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

function download(di, gs)

    BioLab.Error.error_missing(di)

    gz = "$(gs)_family.soft.gz"

    Base.download(
        "ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs[1:(end - 3)])nnn/$gs/soft/$gz",
        joinpath(di, gz),
    )

end

function _readline(io)

    readline(io; keep = false)

end

function _eachsplit(li)

    eachsplit(li, " = "; limit = 2)

end

function read(gz)

    bl_th = Dict(
        "DATABASE" => OrderedDict{String, OrderedDict{String, String}}(),
        "SERIES" => OrderedDict{String, OrderedDict{String, String}}(),
        "PLATFORM" => OrderedDict{String, OrderedDict{String, String}}(),
        "SAMPLE" => OrderedDict{String, OrderedDict{String, String}}(),
    )

    bl = ""

    th = ""

    be = ""

    io = open(gz)

    while !eof(io)

        li = _readline(io)

        if startswith(li, '^')

            bl, th = _eachsplit(li[2:end])

            bl_th[bl][th] = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif startswith(li, be)

            ta = readuntil(io, "$(be[1:(end - 5)])end\n")

            n_ro = count('\n', ta)

            n_rok = 1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            if n_ro == n_rok

                bl_th[bl][th]["table"] = ta

            else

                @warn "\"$th\" table's numbers of rows differ. $n_ro != $n_rok."

            end

        else

            ke, va = _eachsplit(li)

            BioLab.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    bl_th

end

function _dice(ta)

    split.(eachsplit(ta, '\n'; keepempty = false), '\t')

end

function _map(pl, ta)

    pli = parse(Int, pl[4:end])

    if pli in (96, 97, 570, 13667)

        co = "Gene Symbol"

        fu = fe -> BioLab.String.split_get(fe, " /// ", 1)

    elseif pli == 13534

        co = "UCSC_RefGene_Name"

        fu = fe -> BioLab.String.split_get(fe, ';', 1)

    elseif pli in (5175, 6244, 11532, 17586)

        co = "gene_assignment"

        fu = fe -> BioLab.String.split_get(fe, " // ", 2)

    elseif pli in (2004, 2005, 3718, 3720)

        co = "Associated Gene"

        fu = fe -> BioLab.String.split_get(fe, " // ", 1)

    elseif pli in (6098, 6884, 6947, 10558, 14951)

        co = "Symbol"

        fu = fe -> fe

    elseif pli == 16686

        co = "GB_ACC"

        fu = fe -> fe

    elseif pli == 10332

        co = "GENE_SYMBOL"

        fu = fe -> fe

    elseif pli == 15048

        co = "GeneSymbol"

        fu = fe -> BioLab.String.split_get(fe, ' ', 1)

    elseif pli in (7566, 7567)

        error("\"$pl\" is bad.")

    else

        error("\"$pl\" is new.")

    end

    fe_fe2 = Dict{String, String}()

    sp___ = _dice(ta)

    sp1_ = sp___[1]

    id1 = findfirst(==("ID"), sp1_)

    id2 = findfirst(==(co), sp1_)

    for sp_ in view(sp___, 2:length(sp___))

        fe2 = sp_[id2]

        if !BioLab.Bad.is(fe2)

            fe_fe2[sp_[id1]] = fu(fe2)

        end

    end

    fe_fe2

end

function tabulate(bl_th, sa = "!Sample_title")

    sa_ke_va = OrderedDict(ke_va[sa] => ke_va for ke_va in values(bl_th["SAMPLE"]))

    n = length(sa_ke_va)

    sa_ = Vector{String}(undef, n)

    ch_st__ = Vector{Dict{String, String}}(undef, n)

    pl_fe_fl__ = Dict{String, Vector{Dict{String, Float64}}}()

    de = ": "

    for (id, (sa, ke_va)) in enumerate(sa_ke_va)

        sa_[id] = sa

        ch_st__[id] = Dict{String, String}()

        for (ke, va) in ke_va

            if startswith(ke, "!Sample_characteristics")

                if contains(va, de)

                    ch, st = eachsplit(va, de; limit = 2)

                    ch_st__[id][ch] = st

                else

                    @warn "\"$sa\" characteristic \"$va\" lacks \"$de\"."

                end

            end

        end

        if haskey(ke_va, "table")

            pl = ke_va["!Sample_platform_id"]

            if !haskey(pl_fe_fl__, pl)

                pl_fe_fl__[pl] = Vector{Dict{String, Float64}}(undef, n)

            end

            sp___ = _dice(ke_va["table"])

            idv = findfirst(==("VALUE"), sp___[1])

            pl_fe_fl__[pl][id] =
                Dict(sp_[1] => parse(Float64, sp_[idv]) for sp_ in view(sp___, 2:length(sp___)))

        else

            @warn "\"$sa\" lacks a table."

        end

    end

    na_feature_x_sample_x_any =
        Dict("Characteristic" => BioLab.DataFrame.make("Characteristic", sa_, ch_st__))

    for (pl, fe_fl__) in pl_fe_fl__

        feature_x_sample_x_float = BioLab.DataFrame.make(pl, sa_, fe_fl__)

        if !isempty(feature_x_sample_x_float)

            ke_va = bl_th["PLATFORM"][pl]

            if haskey(ke_va, "table")

                fe_fe2 = _map(pl, ke_va["table"])

                # TODO: Benchmark a for-loop.
                # TODO: Consider `rename`.
                feature_x_sample_x_float[!, 1] =
                    [Base.get(fe_fe2, id, "_$id") for id in feature_x_sample_x_float[!, 1]]

            else

                error("\"$pl\" lacks a table.")

            end

        end

        na_feature_x_sample_x_any[pl] = feature_x_sample_x_float

    end

    na_feature_x_sample_x_any

end

# TODO: Test.
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

    na_feature_x_sample_x_any = BioLab.GEO.tabulate(bl_th; sa)

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

    fe_, fe_x_sa_x_nu = rename_collapse_log2_plot(ou, fe_, fe_x_sa_x_nu, fe_fe2, lo, gs)

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
