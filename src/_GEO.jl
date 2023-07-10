module GEO

using DataFrames: DataFrame

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

function _readline(st)

    readline(st; keep = false)

end

function download(di, gs)

    na = "$(gs)_family.soft.gz"

    gz = joinpath(di, na)

    BioLab.Path.warn_overwrite(gz)

    gs2 = gs[1:(end - 3)]

    Base.download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs2)nnn/$gs/soft/$na", gz)

end

function read(gz)

    # TODO: Benchmark against hard-coding.
    ty_bl_ke_va = Dict(
        ty => OrderedDict{String, OrderedDict{String, String}}() for
        ty in ("DATABASE", "SERIES", "PLATFORM", "SAMPLE")
    )

    ty = ""

    bl = ""

    eq = " = "

    st = open(gz)

    while !eof(st)

        li = _readline(st)

        if startswith(li, '^')

            ty, bl = split(li[2:end], eq; limit = 2)

            ty_bl_ke_va[ty][bl] = OrderedDict{String, String}()

            continue

        end

        tyl = lowercase(ty)

        ta = "!$(tyl)_table_"

        if startswith(li, "$(ta)begin")

            tyt = titlecase(ty)

            ty_bl_ke_va[ty][bl]["table"] = join(
                (
                    _readline(st) for
                    _ in 1:(1 + parse(Int, ty_bl_ke_va[ty][bl]["!$(tyt)_data_row_count"]))
                ),
                '\n',
            )

            if _readline(st) != "$(ta)end"

                error("$ta did not end.")

            end

            continue

        end

        # TODO: Consider keeping only important information.
        ke, va = split(li, eq; limit = 2)

        BioLab.Dict.set_with_suffix!(ty_bl_ke_va[ty][bl], ke, va)

    end

    close(st)

    ty_bl_ke_va

end

function _map_feature(pl, ta)

    it = parse(Int, pl[4:end])

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

    # TODO: Consider using BioLab.DataFrame.map.

    id_fe = Dict{String, String}()

    for (id, fe) in zip(ta[!, "ID"], ta[!, co])

        if fe isa AbstractString && !isempty(fe) && fe != "---"

            BioLab.Dict.set_with_last!(id_fe, id, fu(fe))

        end

    end

    id_fe

end

function make(nar, co_, ro_an__)

    ro_ = sort!(collect(union(Base.map(keys, ro_an__)...)))

    an__ = [Vector{Any}(undef, 1 + length(co_)) for _ in 1:(1 + length(ro_))]

    id = 1

    an__[id][1] = nar

    an__[id][2:end] = co_

    for (id, ro) in enumerate(ro_)

        id = 1 + id

        an__[id][1] = ro

        an__[id][2:end] .= (get(ro_an, ro, missing) for ro_an in ro_an__)

    end

    make(an__)

end

function tabulate(ty_bl_ke_va; sa = "!Sample_title", ig_ = ())

    sa_ke_va = OrderedDict(ke_va[sa] => ke_va for ke_va in values(ty_bl_ke_va["SAMPLE"]))

    sa_ = collect(keys(sa_ke_va))

    n_sa = length(sa_)

    de = ": "

    ch_st__ = fill(Dict{String, String}(), n_sa)

    pl_fe_fl__ = Dict{String, Vector{Dict{String, Float64}}}()

    for (id, (sa, ke_va)) in enumerate(sa_ke_va)

        ch_ = [
            va for (ke, va) in ke_va if startswith(ke, "!Sample_characteristics") &&
            (isempty(ig_) || !any(contains(va, ig) for ig in ig_))
        ]

        if all(contains(ch, de) for ch in ch_)

            merge!(ch_st__[id], Dict(split(ch, de; limit = 2) for ch in ch_))

        else

            @warn "A $sa characteristic lacks $de." ch_

        end

        if haskey(ke_va, "table")

            ta = BioLab.DataFrame.make(ke_va["table"])

            merge!(
                get!(
                    pl_fe_fl__,
                    ke_va["!Sample_platform_id"],
                    fill(Dict{String, Float64}(), n_sa),
                )[id],
                Dict(zip(ta[!, 1], map(st -> parse(Float64, st), ta[!, "VALUE"]))),
            )

        else

            @error "$sa table is empty."

        end

    end

    da_ = Vector{DataFrame}(undef, length(pl_fe_fl__))

    for (id, (pl, fe_fl__)) in enumerate(pl_fe_fl__)

        da = _make(pl, sa_, fe_fl__)

        ke_va = ty_bl_ke_va["PLATFORM"][pl]

        if haskey(ke_va, "table")

            id_fe = _map_feature(pl, BioLab.DataFrame.make(ke_va["table"]))

            da[!, 1] = [get(id_fe, id, "_$id") for id in da[!, 1]]

        else

            @warn "$pl table is empty."

        end

        da_[id] = da

    end

    _make("Characteristic", sa_, ch_st__), da_...

end

end
