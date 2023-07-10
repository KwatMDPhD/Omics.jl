module GEO

using DataFrames: DataFrame

using GZip: open

using OrderedCollections: OrderedDict

using BioLab

function download(di, gs)

    na = "$(gs)_family.soft.gz"

    gz = joinpath(di, na)

    BioLab.Path.warn_overwrite(gz)

    gs2 = chop(gs; tail = 3)

    Base.download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs2)nnn/$gs/soft/$na", gz)

end

function _readline(st)

    readline(st; keep = false)

end

function _split(li)

    split(li, " = "; limit = 2)

end

function read(gz)

    bl_th_ke_va = Dict(
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

            bl, th = _split(chop(li; head = 1, tail = 0))

            bl_th_ke_va[bl][th] = OrderedDict{String, String}()

            continue

        end

        bll = lowercase(bl)

        ta = "!$(bll)_table_"

        if startswith(li, "$(ta)begin")

            blt = titlecase(bl)

            bl_th_ke_va[bl][th]["table"] = join(
                (
                    _readline(st) for
                    _ in 1:(1 + parse(Int, bl_th_ke_va[bl][th]["!$(blt)_data_row_count"]))
                ),
                '\n',
            )

            if _readline(st) != "$(ta)end"

                error("$ta did not end.")

            end

            continue

        end

        ke, va = _split(li)

        BioLab.Dict.set_with_suffix!(bl_th_ke_va[bl][th], ke, va)

    end

    close(st)

    bl_th_ke_va

end

function _map_feature(pl, ta)

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

    elseif it in (7566, 7567)

        error("$pl is a bad platform. Avoid it.")

    else

        error("$pl is a new platform. Implement it.")

    end

    id_fe = Dict{String, String}()

    for (id, fe) in zip(ta[!, "ID"], ta[!, co])

        if fe isa AbstractString && !isempty(fe) && fe != "---"

            BioLab.Dict.set_with_last!(id_fe, id, fu(fe))

        end

    end

    id_fe

end

function _make(nar, co_, ro_an__)

    ro_ = sort!(collect(union(keys.(ro_an__)...)))

    if isempty(ro_)

        return

    end

    an__ = [Vector{Any}(undef, 1 + length(co_)) for _ in 1:(1 + length(ro_))]

    id = 1

    an__[id][1] = nar

    an__[id][2:end] = co_

    for (id, ro) in enumerate(ro_)

        id += 1

        an__[id][1] = ro

        an__[id][2:end] = [get(ro_an, ro, missing) for ro_an in ro_an__]

    end

    BioLab.DataFrame.make(an__)

end

function _make(st)

    BioLab.DataFrame.make(split.(eachsplit(st, '\n'), '\t'))

end

function tabulate(bl_th_ke_va; sa = "!Sample_title")

    sa_ke_va = OrderedDict(ke_va[sa] => ke_va for ke_va in values(bl_th_ke_va["SAMPLE"]))

    sa_ = collect(keys(sa_ke_va))

    n_sa = length(sa_)

    de = ": "

    ch_st__ = [Dict{String, String}() for _ in 1:n_sa]

    pl_fe_fl__ = Dict{String, Vector{Dict{String, Float64}}}()

    for (id, (sa, ke_va)) in enumerate(sa_ke_va)

        ch_ = [va for (ke, va) in ke_va if startswith(ke, "!Sample_characteristics")]

        if all(contains(de), ch_)

            merge!(ch_st__[id], Dict(split(ch, de; limit = 2) for ch in ch_))

        else

            @warn "A $sa characteristic lacks $de." ch_

        end

        if haskey(ke_va, "table")

            ta = _make(ke_va["table"])

            merge!(
                get!(
                    pl_fe_fl__,
                    ke_va["!Sample_platform_id"],
                    [Dict{String, Float64}() for _ in 1:n_sa],
                )[id],
                Dict(zip(ta[!, 1], parse.(Float64, ta[!, "VALUE"]))),
            )

        else

            @error "$sa table is empty."

        end

    end

    da_ = Vector{DataFrame}(undef, length(pl_fe_fl__))

    for (id, (pl, fe_fl__)) in enumerate(pl_fe_fl__)

        da = _make(pl, sa_, fe_fl__)

        ke_va = bl_th_ke_va["PLATFORM"][pl]

        if haskey(ke_va, "table")

            id_fe = _map_feature(pl, _make(ke_va["table"]))

            da[!, 1] = [get(id_fe, id, "_$id") for id in da[!, 1]]

        else

            @warn "$pl table is empty."

        end

        da_[id] = da

    end

    _make("Characteristic", sa_, ch_st__), da_...

end

end
