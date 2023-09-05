module GEO

# TODO: Use BioLab.DataFrame instead.
using DataFrames: DataFrame

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

function download(di, gs)

    BioLab.Error.error_missing(di)

    gz = "$(gs)_family.soft.gz"

    Base.download(
        "ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(chop(gs; tail = 3))nnn/$gs/soft/$gz",
        joinpath(di, gz),
    )

end

function _readline(st)

    readline(st; keep = false)

end

function _eachsplit(li)

    eachsplit(li, " = "; limit = 2)

end

function read(gz)

    bl_th = Dict(
        "DATABASE" =>
            OrderedDict{SubString{String}, OrderedDict{SubString{String}, SubString{String}}}(),
        "SERIES" =>
            OrderedDict{SubString{String}, OrderedDict{SubString{String}, SubString{String}}}(),
        "PLATFORM" =>
            OrderedDict{SubString{String}, OrderedDict{SubString{String}, SubString{String}}}(),
        "SAMPLE" =>
            OrderedDict{SubString{String}, OrderedDict{SubString{String}, SubString{String}}}(),
    )

    bl = ""

    th = ""

    st = open(gz)

    while !eof(st)

        li = _readline(st)

        if startswith(li, '^')

            bl, th = _eachsplit(chop(li; head = 1, tail = 0))

            bl_th[bl][th] = OrderedDict{SubString{String}, SubString{String}}()

            continue

        end

        pr = "!$(lowercase(bl))_table_"

        if startswith(li, "$(pr)begin")

            en = "$(pr)end"

            ro_ = Vector{SubString{String}}()

            n_ro = 0

            ro = _readline(st)

            while ro != en

                push!(ro_, ro)

                n_ro += 1

                ro = _readline(st)

            end

            n_ro2 = 1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            if n_ro != n_ro2

                @warn "Table has $n_ro rows, which do not match $n_ro2."

            end

            bl_th[bl][th]["table"] = join(ro_, '\n')

            continue

        end

        ke, va = _eachsplit(li)

        BioLab.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

    end

    close(st)

    bl_th

end

function _map_feature(pl, co_, sp___)

    it = parse(Int, chop(pl; head = 3, tail = 0))

    if it in (96, 97, 570, 13667)

        co = "Gene Symbol"

        fu = fe -> BioLab.String.split_get(fe, " /// ", 1)

    elseif it == 13534

        co = "UCSC_RefGene_Name"

        fu = fe -> BioLab.String.split_get(fe, ';', 1)

    elseif it in (5175, 6244, 11532, 17586)

        co = "gene_assignment"

        fu = fe -> BioLab.String.split_get(fe, " // ", 2)

    elseif it in (2004, 2005, 3718, 3720)

        co = "Associated Gene"

        fu = fe -> BioLab.String.split_get(fe, " // ", 1)

    elseif it in (6098, 6884, 6947, 10558, 14951)

        co = "Symbol"

        fu = fe -> fe

    elseif it == 16686

        co = "GB_ACC"

        fu = fe -> fe

    elseif it == 10332

        co = "GENE_SYMBOL"

        fu = fe -> fe

    elseif it == 15048

        co = "GeneSymbol"

        fu = fe -> BioLab.String.split_get(fe, ' ', 1)

    elseif it in (7566, 7567)

        error("$pl is a bad platform. Avoid it.")

    else

        error("$pl is a new platform. Implement it.")

    end

    id_fe = Dict{String, String}()

    idi = findfirst(==("ID"), co_)

    idc = findfirst(==(co), co_)

    for sp_ in sp___

        fe = sp_[idc]

        if !BioLab.Bad.is(fe)

            id_fe[sp_[idi]] = fu(fe)

        end

    end

    id_fe

end

function _make(nar, co_, ro_an__)

    ro_ = union(keys.(ro_an__)...)

    if isempty(ro_)

        return DataFrame()

    end

    DataFrame(
        BioLab.Matrix.make([
            vcat(ro, [get(ro_an, ro, missing) for ro_an in ro_an__]) for ro in sort!(collect(ro_))
        ]),
        vcat(nar, co_),
    )

end

function tabulate(bl_th; sa = "!Sample_title")

    sa_di = OrderedDict(ke_va[sa] => ke_va for ke_va in values(bl_th["SAMPLE"]))

    sa_ = collect(keys(sa_di))

    ids_ = 1:length(sa_)

    de = ": "

    ch_st__ = [Dict{String, String}() for _ in ids_]

    pl_fe_fl__ = Dict{String, Vector{Dict{String, Float64}}}()

    for (ids, (sa, ke_va)) in enumerate(sa_di)

        ch_ = [va for (ke, va) in ke_va if startswith(ke, "!Sample_characteristics")]

        if all(contains(de), ch_)

            merge!(ch_st__[ids], Dict(eachsplit(ch, de; limit = 2) for ch in ch_))

        else

            @warn "A $sa characteristic lacks $de." ch_

        end

        if haskey(ke_va, "table")

            sp___ = BioLab.String.dice(ke_va["table"])

            idv = findfirst(==("VALUE"), sp___[1])

            pl = ke_va["!Sample_platform_id"]

            if !haskey(pl_fe_fl__, pl)

                pl_fe_fl__[pl] = [Dict{String, Float64}() for _ in ids_]

            end

            merge!(
                pl_fe_fl__[pl][ids],
                Dict(sp_[1] => parse(Float64, sp_[idv]) for sp_ in view(sp___, 2:length(sp___))),
            )

        else

            @warn "$sa table is empty."

        end

    end

    pl_da = Dict{String, DataFrame}()

    for (pl, fe_fl__) in pl_fe_fl__

        da = _make(pl, sa_, fe_fl__)

        if !isempty(da)

            ke_va = bl_th["PLATFORM"][pl]

            if haskey(ke_va, "table")

                sp___ = BioLab.String.dice(ke_va["table"])

                id_fe = _map_feature(pl, sp___[1], view(sp___, 2:length(sp___)))

                da[!, 1] = [get(id_fe, id, "_$id") for id in da[!, 1]]

            else

                error("$pl table is empty.")

            end

        end

        pl_da[pl] = da

    end

    _make("Characteristic", sa_, ch_st__), pl_da

end

# TODO: Test.
function get(
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

    fe_, fe_x_sa_x_nu = rename_collapse_log2_plot(ou, fe_, fe_x_sa_x_nu, fe_fe2, lo, gs)

    nafc = BioLab.Path.clean(naf)

    pr = joinpath(ou, "$(nafc)_x_$(nasc)_x_number")

    BioLab.DataFrame.write("$pr.tsv", BioLab.DataFrame.make(naf, fe_, sa_, fe_x_sa_x_nu))

    title_text = gs

    if isempty(chg)

        grc_ = Vector{Int}()

    else

        grc_ = BioLab.String.try_parse.(view(ch_x_sa_x_an, findfirst(==(chg), ch_), :))

        title_text = string(title_text, " Grouped by ", titlecase(chg))

    end

    BioLab.Plot.plot_heat_map(
        string(pr, ".html"),
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
