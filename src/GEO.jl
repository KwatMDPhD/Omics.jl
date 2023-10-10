module GEO

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

function _eachsplit(li, de)

    eachsplit(li, de; limit = 2)

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

    de = ": "

    while !eof(io)

        li = readline(io; keep = false)

        if startswith(li, '^')

            bl, th = _eachsplit(li[2:end], " = ")

            bl_th[bl][th] = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif startswith(li, be)

            ta = readuntil(io, "$(be[1:(end - 5)])end\n")

            n_ro = count('\n', ta)

            n_rok = 1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            if n_ro == n_rok

                bl_th[bl][th]["_ta"] = ta

            else

                @warn "\"$th\" table's numbers of rows differ. $n_ro != $n_rok."

            end

        else

            ke, va = _eachsplit(li, " = ")

            if startswith(ke, "!Sample_characteristics")

                if contains(va, de)

                    pr, va = _eachsplit(va, de)

                    ke = "_ch.$pr"

                else

                    @warn "\"$va\" lacks \"$de\"."

                end

            end

            BioLab.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    bl_th

end

function _dice(ta)

    split.(eachsplit(ta, '\n'; keepempty = false), '\t')

end

function _map(pl_va)

    pl = pl_va["!Platform_geo_accession"]

    if !haskey(pl_va, "_ta")

        error("\"$pl\" lacks a table.")

    end

    pli = parse(Int, pl[4:end])

    fu = identity

    if pli == 16686

        co = "GB_ACC"

    elseif pli == 10332

        co = "GENE_SYMBOL"

    elseif pli in (6098, 6884, 6947, 10558, 14951)

        co = "Symbol"

    elseif pli == 15048

        co = "GeneSymbol"

        fu = fe -> BioLab.String.split_get(fe, ' ', 1)

    elseif pli == 13534

        co = "UCSC_RefGene_Name"

        fu = fe -> BioLab.String.split_get(fe, ';', 1)

    elseif pli in (2004, 2005, 3718, 3720)

        co = "Associated Gene"

        fu = fe -> BioLab.String.split_get(fe, " // ", 1)

    elseif pli in (5175, 6244, 11532, 17586)

        co = "gene_assignment"

        fu = fe -> BioLab.String.split_get(fe, " // ", 2)

    elseif pli in (96, 97, 570, 13667)

        co = "Gene Symbol"

        fu = fe -> BioLab.String.split_get(fe, " /// ", 1)

    else

        error("\"$pl\" is new.")

    end

    sp___ = _dice(pl_va["_ta"])

    sp1_ = sp___[1]

    id = findfirst(==("ID"), sp1_)

    id2 = findfirst(==(co), sp1_)

    fe_ = Vector{String}()

    fe2_ = Vector{String}()

    for sp_ in view(sp___, 2:length(sp___))

        push!(fe_, sp_[id])

        push!(fe2_, fu(sp_[id2]))

    end

    fe_, fe2_

end

function get_sample(sa_ke_va, sa = "!Sample_title")

    [ke_va[sa] for ke_va in values(sa_ke_va)]

end

function tabulate(sa_ke_va)

    ke_va__ = values(sa_ke_va)

    # TODO: Benchmark `Vector`.
    ch = Set{String}()

    for ke_va in ke_va__

        for ke in keys(ke_va)

            if startswith(ke, "_ch")

                push!(ch, ke)

            end

        end

    end

    ch_ = sort!(collect(ch))

    # TODO: Benchmark `fill`.
    [titlecase(ch[5:end]) for ch in ch_], [get(ke_va, ch, "") for ch in ch_, ke_va in ke_va__]

end

function tabulate(pl_va, sa_ke_va)

    fe_, fe2_ = _map(pl_va)

    fe_x_sa_x_fl = fill(NaN, length(fe_), length(sa_ke_va))

    fe_id = BioLab.Collection.map_index(fe_)

    for (id, (sa, ke_va)) in enumerate(sa_ke_va)

        if haskey(ke_va, "_ta")

            sp___ = _dice(ke_va["_ta"])

            idv = findfirst(==("VALUE"), sp___[1])

            for sp_ in view(sp___, 2:length(sp___))

                fe_x_sa_x_fl[fe_id[sp_[1]], id] = parse(Float64, sp_[idv])

            end

        else

            @warn "\"$sa\" lacks a table."

        end

    end

    fe2_, fe_x_sa_x_fl

end

end
