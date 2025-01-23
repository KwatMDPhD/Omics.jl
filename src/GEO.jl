module GEO

using GZip: open

using OrderedCollections: OrderedDict

using ..Omics

function make_soft(gs)

    "$(gs)_family.soft.gz"

end

function rea(so)

    bl_th = Dict(
        "DATABASE" => OrderedDict{String, OrderedDict{String, String}}(),
        "SERIES" => OrderedDict{String, OrderedDict{String, String}}(),
        "PLATFORM" => OrderedDict{String, OrderedDict{String, String}}(),
        "SAMPLE" => OrderedDict{String, OrderedDict{String, String}}(),
    )

    bl = th = ta = ""

    dk = " = "

    dc = ": "

    io = open(so)

    while !eof(io)

        li = readline(io; keep = false)

        if li[1] == '^'

            bl, th = eachsplit(li[2:end], dk; limit = 2)

            bl_th[bl][th] = OrderedDict{String, String}()

            ta = "!$(lowercase(bl))_table_begin"

        elseif li == ta

            bl_th[bl][th]["_he"] = readline(io; keep = false)

            bl_th[bl][th]["_bo"] = readuntil(io, "$(ta[1:(end - 5)])end\n")

        else

            ke, va = eachsplit(li, dk; limit = 2)

            if startswith(ke, "!Sample_characteristics") && contains(va, dc)

                ch, va = eachsplit(va, dc; limit = 2)

                ke = "_ch$ch"

            end

            Omics.Dic.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    bl_th

end

function _name_sample(ke_va)

    "$(ke_va["!Sample_geo_accession"]) $(ke_va["!Sample_title"])"

end

function get_sample(bl_th)

    sa_ = map(_name_sample, values(bl_th["SAMPLE"]))

    @info "👥" sa_

    sa_

end

function get_characteristic(bl_th)

    ke_va__ = values(bl_th["SAMPLE"])

    ch_ = String[]

    for ke_va in ke_va__, ke in keys(ke_va)

        if ke[1:3] == "_ch"

            push!(ch_, ke)

        end

    end

    unique!(ch_)

    va = [get(ke_va, ch, "") for ch in ch_, ke_va in ke_va__]

    map!(ch -> ch[4:end], ch_, ch_)

    @info "🔬" ch_ va

    ch_, va

end

function get_platform(bl_th)

    pl = collect(keys(bl_th["PLATFORM"]))[]

    @info "🧪 $pl."

    pl

end

function _each(bo)

    (split(li, '\t') for li in eachsplit(bo, '\n'; keepempty = false))

end

function get_feature(bl_th, pl)

    fe_ = map(sp_ -> sp_[1], _each(bl_th["PLATFORM"][pl]["_bo"]))

    ke_va__ = filter!(
        ke_va -> ke_va["!Sample_platform_id"] == pl,
        collect(values(bl_th["SAMPLE"])),
    )

    uf = lastindex(fe_)

    us = length(ke_va__)

    va = fill(NaN, uf, us)

    is_ = falses(uf)

    fe_ie = Omics.Dic.index(fe_)

    for is in 1:us

        ke_va = ke_va__[is]

        iv = findfirst(==("VALUE"), split(ke_va["_he"], '\t'))

        for sp_ in _each(ke_va["_bo"])

            vl = sp_[iv]

            if isempty(vl) || vl == "null"

                continue

            end

            ie = fe_ie[sp_[1]]

            va[ie, is] = parse(Float64, vl)

            if !is_[ie]

                is_[ie] = true

            end

        end

    end

    fe_ = fe_[is_]

    va = va[is_, :]

    sa_ = map(_name_sample, ke_va__)

    @info "🧬 $pl $(lastindex(fe_)) / $uf" fe_ sa_ va

    fe_, sa_, va

end

function _get_slash_slash_2(st)

    split_get(st, " // ", 2)

end

function _get_hgnc_map(hk_)

    Omics.Gene.ma(Omics.Table.rea(Omics.Gene.HT), hk_, Omics.Gene.HV)

end

function get_map(bl_th, pl)

    it = parse(Int, pl[4:end])

    fu = identity

    if it == 96 ||
       it == 97 ||
       it == 570 ||
       it == 571 ||
       it == 3921 ||
       it == 4685 ||
       it == 13158 ||
       it == 13667 ||
       it == 15207

        co = "Gene Symbol"

        fu = ge -> split_get(ge, " /// ", 1)

    elseif it == 5175 || it == 6244 || it == 11532 || it == 17586

        co = "gene_assignment"

        fu = _get_slash_slash_2

    elseif it == 6098 ||
           it == 6104 ||
           it == 6883 ||
           it == 6884 ||
           it == 6947 ||
           it == 10558 ||
           it == 14951

        co = "Symbol"

    elseif it == 7567 || it == 9700 || it == 10465 || it == 16686

        co = "GB_ACC"

        ke_va = _get_hgnc_map(["refseq_accession", "ena"])

        fu = ge -> get(ke_va, ge, ge)

    elseif it == 9741 || it == 9742

        co = "Official Symbol"

    elseif it == 10647 || it == 21975

        co = "ENTREZ_GENE_ID"

        ke_va = _get_hgnc_map(["entrez_id"])

        fu = ge -> get(ke_va, ge, ge)

    elseif it == 32416

        co = "SPOT_ID"

        ke_va = _get_hgnc_map(["entrez_id"])

        fu = ge -> get(ke_va, ge, ge)

    elseif it == 1708 || it == 6480 || it == 10332

        co = "GENE_SYMBOL"

    elseif it == 15048

        co = "GeneSymbol"

        fu = ge -> split_get(ge, ' ', 1)

    elseif it == 16209

        co = "gene_assignment"

        fu = ge -> _get_slash_slash_2(split_get(ge, " /// ", 1))

    elseif it == 17585 || it == 17586

        co = "gene_symbols"

    elseif it == 23126

        co = "gene_assignment"

        fu = ge -> contains(ge, "AceView") ? "" : _get_slash_slash_2(ge)

    elseif it == 25336

        co = "ORF"

    elseif it == 10999 || it == 16791

        error("\"$pl\" lacks gene mapping.")

    elseif it == 13669

        co = "Description"

        fu =
            ge ->
                contains(ge, '(') ?
                ge[(findlast(==('('), ge) + 1):(findlast(==(')'), ge) - 1)] : ge

    else

        error("\"$pl\" is new.")

    end

    fe_ge = Dict{String, String}()

    id = findfirst(==(co), split(bl_th["PLATFORM"][pl]["_he"], '\t'))

    for sp_ in _each(bl_th["PLATFORM"][pl]["_bo"])

        ge = sp_[id]

        if !Omics.Strin.is_bad(ge)

            fe_ge[sp_[1]] = fu(ge)

        end

    end

    fe_ge

end

function ge(so)

    bl_th = _read(so)

    sa_ = _get_sample(bl_th)

    ch_, va = _get_characteristic(bl_th)

    bl_th, sa_, ch_, va

end

function ge(pr, so, pl = ""; ns = "All", lo = false, ta = "", ps_ = (), pf_ = ())

    bl_th, sa_, ch_, vc = ge(so)

    if isempty(pl)

        pl = _get_platform(bl_th)

    end

    fe_, sm_, vf = _get_feature(bl_th, pl)

    vc = vc[:, indexin(sm_, sa_)]

    fe_, vf = Omics.XSample.process(fe_, vf; fe_fa = get_map(bl_th, pl), lo)

    Omics.XSample.write(pr, ns, sm_, ch_, vc, pl, fe_, vf, ta, ps_, pf_)

end

end
