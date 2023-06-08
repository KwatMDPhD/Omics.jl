module GEO

using DataFrames: DataFrame, outerjoin, select!

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

function _readline(st)

    readline(st; keep = false)

end

function read(gs; di = BioLab.TE)

    fi = "$(gs)_family.soft.gz"

    gz = joinpath(di, fi)

    if !ispath(gz)

        download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs[1:end-3])nnn/$gs/soft/$fi", gz)

    end

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

        ta = "!$(lowercase(ty))_table_"

        if startswith(li, "$(ta)begin")

            ty_bl_ke_va[ty][bl]["table"] = join(
                (
                    _readline(st) for _ in
                    1:(1 + parse(Int, ty_bl_ke_va[ty][bl]["!$(titlecase(ty))_data_row_count"]))
                ),
                '\n',
            )

            _readline(st)

            continue

        end

        ke, va = split(li, eq; limit = 2)

        BioLab.Dict.set_with_suffix!(ty_bl_ke_va[ty][bl], ke, va)

    end

    close(st)

    ty_bl_ke_va

end

function _name(pl, fe_x_io_x_an)

    pli = parse(Int, pl[4:end])

    ke = "ID"

    if pli in (96, 97, 570, 13667)

        va = "Gene Symbol"

        fu = na -> BioLab.String.split_get(na, " /// ", 1)

    elseif pli == 13534

        va = "UCSC_RefGene_Name"

        fu = na -> BioLab.String.split_get(na, ';', 1)

    elseif pli in (5175, 6244, 11532, 17586)

        va = "gene_assignment"

        fu = na -> BioLab.String.split_get(na, " // ", 2)

    elseif pli in (2004, 2005, 3718, 3720)

        va = "Associated Gene"

        fu = na -> BioLab.String.split_get(na, " // ", 1)

    elseif pli in (6098, 6884, 6947, 10558, 14951)

        va = "Symbol"

        fu = na -> na

    elseif pli == 16686

        va = "GB_ACC"

        fu = na -> na

    elseif pli == 10332

        va = "GENE_SYMBOL"

        fu = na -> na

    elseif pli in (7566, 7567)

        error("$pli is a bad platform. Avoid it.")

    else

        error("$pli is a new platform. Implement it.")

    end

    fe_na = Dict{String, String}()

    for (fe, na) in zip(fe_x_io_x_an[!, ke], fe_x_io_x_an[!, va])

        if na isa AbstractString && !isempty(na) && na != "---"

            BioLab.Dict.set_with_last!(fe_na, fe, fu(na))

        end

    end

    fe_na

end

function _data_frame_outerjoin_select(co_va____, on)

    if isempty(co_va____)

        DataFrame()

    else

        select!(outerjoin((DataFrame(co_va_) for co_va_ in co_va____)...; on), on, :)

    end

end

function tabulate(ty_bl_ke_va; sa = "!Sample_title", ig_ = ())

    sa_ke_va = OrderedDict(ke_va[sa] => ke_va for ke_va in values(ty_bl_ke_va["SAMPLE"]))

    ch = "Characteristic"

    de = ": "

    co_st____ = Vector{Dict{String, Vector{String}}}()

    pl_co_nu____ = Dict{String, Vector{Dict{String, Vector{Any}}}}()

    for (sa, ke_va) in sa_ke_va

        ch_ = [
            va for (ke, va) in ke_va if startswith(ke, "!Sample_characteristics") &&
            (isempty(ig_) || !any(contains(va, ig) for ig in ig_))
        ]

        if all(contains(ch, de) for ch in ch_)

            sp_ = [split(ch, de; limit = 2) for ch in ch_]

            push!(co_st____, Dict(ch => [sp[1] for sp in sp_], sa => [sp[2] for sp in sp_]))

        else

            @warn "A $sa characteristic lacks $de." ch_

        end

        pl = ke_va["!Sample_platform_id"]

        co_nu____ = get!(pl_co_nu____, pl, Vector{Dict{String, Vector{Any}}}())

        if haskey(ke_va, "table")

            fe_x_io_x_an = BioLab.DataFrame.make(ke_va["table"])

            push!(
                co_nu____,
                Dict(
                    pl => fe_x_io_x_an[!, 1],
                    sa => [parse(Float64, va) for va in fe_x_io_x_an[!, "VALUE"]],
                ),
            )

        else

            @warn "$sa table is empty."

        end

    end

    ch_x_sa_x_an = _data_frame_outerjoin_select(co_st____, ch)

    fe_x_sa_x_nu_____ = Vector{DataFrame}(undef, length(pl_co_nu____))

    for (id, (pl, co_nu____)) in enumerate(pl_co_nu____)

        fe_x_sa_x_nu = _data_frame_outerjoin_select(co_nu____, pl)

        pl_ke_va = ty_bl_ke_va["PLATFORM"]

        if haskey(pl_ke_va[pl], "table")

            fe_na = _name(pl, BioLab.DataFrame.make(pl_ke_va[pl]["table"]))

            fe_x_sa_x_nu[!, 1] = [get(fe_na, fe, "_$fe") for fe in fe_x_sa_x_nu[!, 1]]

        else

            @warn "$pl table is empty."

        end

        fe_x_sa_x_nu_____[id] = fe_x_sa_x_nu

    end

    ch_x_sa_x_an, fe_x_sa_x_nu_____...

end

end
