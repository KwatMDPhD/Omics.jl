module GEO

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

function download(di, gs)

    BioLab.Error.error_missing(di)

    gz = "$(gs)_family.soft.gz"

    Base.download(
        "ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(view(gs, 1:(lastindex(gs) - 3)))nnn/$gs/soft/$gz",
        joinpath(di, gz),
    )

end

function _sp(st, de)

    (string(st) for st in eachsplit(st, de; limit = 2))

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

    de1 = " = "

    de2 = ": "

    while !eof(io)

        li = readline(io; keep = false)

        if startswith(li, '^')

            bl, th = _sp(view(li, 2:length(li)), de1)

            bl_th[bl][th] = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif startswith(li, be)

            ta = readuntil(io, "$(be[1:(end - 5)])end\n")

            n_ro = count('\n', ta)

            n_rod = 1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            if n_ro == n_rod

                bl_th[bl][th]["_ta"] = ta

            else

                @warn "\"$th\" table's numbers of rows differ. $n_ro != $n_rod."

            end

        else

            ke, va = _sp(li, de1)

            if startswith(ke, "!Sample_characteristics")

                if contains(va, de2)

                    pr, va = _sp(va, de2)

                    ke = "_ch.$pr"

                else

                    @warn "\"$va\" lacks \"$de2\"."

                end

            end

            BioLab.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    bl_th

end

function get_sample(sa_ke_va, sa = "!Sample_title")

    [ke_va[sa] for ke_va in values(sa_ke_va)]

end

function tabulate(sa_ke_va)

    ke_va__ = values(sa_ke_va)

    ch_ = Vector{String}()

    for ke_va in ke_va__

        for ke in keys(ke_va)

            if startswith(ke, "_ch")

                push!(ch_, ke)

            end

        end

    end

    ch_ = sort!(unique!(ch_))

    ch_x_sa_x_st = [get(ke_va, ch, "") for ch in ch_, ke_va in ke_va__]

    for (id, ch) in enumerate(ch_)

        ch_[id] = titlecase(view(ch, 5:length(ch)))

    end

    ch_, ch_x_sa_x_st

end

function _di(ta)

    split.(eachsplit(ta, '\n'; keepempty = false), '\t')

end

function _fe(ke_va)

    pl = ke_va["!Platform_geo_accession"]

    if !haskey(ke_va, "_ta")

        error("\"$pl\" lacks a table.")

    end

    it = parse(Int, view(pl, 4:length(pl)))

    co = ""

    fu = identity

    if it == 16686

        co = "GB_ACC"

    elseif it == 10332

        co = "GENE_SYMBOL"

    elseif it in (6098, 6884, 6947, 10558, 14951)

        co = "Symbol"

    elseif it == 15048

        co = "GeneSymbol"

        fu = fe -> BioLab.String.split_get(fe, ' ', 1)

    elseif it == 13534

        co = "UCSC_RefGene_Name"

        fu = fe -> BioLab.String.split_get(fe, ';', 1)

    elseif it in (2004, 2005, 3718, 3720)

        co = "Associated Gene"

        fu = fe -> BioLab.String.split_get(fe, " // ", 1)

    elseif it in (5175, 6244, 11532, 17586)

        co = "gene_assignment"

        fu = fe -> BioLab.String.split_get(fe, " // ", 2)

    elseif it in (96, 97, 570, 13667)

        co = "Gene Symbol"

        fu = fe -> BioLab.String.split_get(fe, " /// ", 1)

    else

        error("\"$pl\" is new.")

    end

    sp___ = _di(ke_va["_ta"])

    sp1_ = sp___[1]

    id = findfirst(==("ID"), sp1_)

    idc = findfirst(==(co), sp1_)

    fe_ = Vector{String}()

    fec_ = Vector{String}()

    for sp_ in view(sp___, 2:length(sp___))

        push!(fe_, sp_[id])

        push!(fec_, fu(sp_[idc]))

    end

    fe_, fec_

end

function tabulate(ke_va, sa_ke_va)

    fe_, fec_ = _fe(ke_va)

    fe_x_sa_x_fl = fill(NaN, length(fe_), length(sa_ke_va))

    fe_id = Dict(fe => id for (id, fe) in enumerate(fe_))

    for (id, (sa, ke_va)) in enumerate(sa_ke_va)

        if haskey(ke_va, "_ta")

            sp___ = _di(ke_va["_ta"])

            idv = findfirst(==("VALUE"), sp___[1])

            for sp_ in view(sp___, 2:length(sp___))

                fe_x_sa_x_fl[fe_id[sp_[1]], id] = parse(Float64, sp_[idv])

            end

        else

            @warn "\"$sa\" lacks a table."

        end

    end

    fec_, fe_x_sa_x_fl

end

end
