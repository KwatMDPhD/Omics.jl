module GEO

# TODO: Use BioLab.DataFrame instead.
using DataFrames: DataFrame

using GZip: open

using OrderedCollections: OrderedDict

using BioLab

function download(di, gs)

    BioLab.Error.error_missing(di)

    gsc = chop(gs; tail = 3)

    gz = "$(gs)_family.soft.gz"

    Base.download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gsc)nnn/$gs/soft/$gz", joinpath(di, gz))

end

function _readline(st)

    readline(st; keep = false)

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

    st = open(gz)

    while !eof(st)

        li = _readline(st)

        if startswith(li, '^')

            bl, th = _eachsplit(chop(li; head = 1, tail = 0))

            bl_th[bl][th] = OrderedDict{String, String}()

            continue

        end

        bll = lowercase(bl)

        pr = "!$(bll)_table_"

        if startswith(li, "$(pr)begin")

            blt = titlecase(bl)

            jo = join(
                (
                    _readline(st) for
                    _ in 1:(1 + parse(Int, bl_th[bl][th]["!$(blt)_data_row_count"]))
                ),
                '\n',
            )

            if _readline(st) == "$(pr)end"

                bl_th[bl][th]["table"] = jo

            else

                @warn "$pr did not end."

            end

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

        return

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

    # TODO: Test.
    pl_da = Dict{String, DataFrame}()

    for (pl, fe_fl__) in pl_fe_fl__

        da = _make(pl, sa_, fe_fl__)

        ke_va = bl_th["PLATFORM"][pl]

        if haskey(ke_va, "table")

            sp___ = BioLab.String.dice(ke_va["table"])

            id_fe = _map_feature(pl, sp___[1], view(sp___, 2:length(sp___)))

            da[!, 1] = [get(id_fe, id, "_$id") for id in da[!, 1]]

        else

            error("$pl table is empty.")

        end

        pl_da[pl] = da

    end

    _make("Characteristic", sa_, ch_st__), pl_da

end

# TODO: Test.
function describe(characteristic_x_sample_x_anything)

    for an_ in eachrow(characteristic_x_sample_x_anything)

        la = an_[1]

        st = BioLab.Collection.count_sort_string(an_[2:end])

        @info "$la\n$st"

    end

end

end
