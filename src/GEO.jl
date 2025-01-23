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

    bl = th = be = ""

    ke_va = OrderedDict{String, String}()

    de = " = "

    dc = ": "

    io = open(so)

    while !eof(io)

        li = readline(io; keep = false)

        if li[1] == '^'

            bl, th = eachsplit(li[2:end], de; limit = 2)

            bl_th[bl][th] = ke_va = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif li == be

            ke_va["_he"] = readline(io; keep = false)

            ke_va["_bo"] = readuntil(io, "$(be[1:(end - 5)])end\n")

        else

            ke, va = eachsplit(li, de; limit = 2)

            if startswith(ke, "!Sample_characteristics") && contains(va, dc)

                ch, va = eachsplit(va, dc; limit = 2)

                ke = "_ch$ch"

            end

            Omics.Dic.set_with_suffix!(ke_va, ke, va)

        end

    end

    close(io)

    bl_th

end

function _name_sample(ke_va)

    "$(ke_va["!Sample_geo_accession"]) $(ke_va["!Sample_title"])"

end

function get_sample(bl_th)

    map(_name_sample, values(bl_th["SAMPLE"]))

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

    vc = [get(ke_va, ch, "") for ch in ch_, ke_va in ke_va__]

    map!(ch -> ch[4:end], ch_, ch_), vc

end

function get_platform(bl_th)

    collect(keys(bl_th["PLATFORM"]))[]

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

    vf = fill(NaN, uf, length(ke_va__))

    is_ = falses(uf)

    fe_ie = Omics.Dic.index(fe_)

    for is in eachindex(ke_va__)

        ke_va = ke_va__[is]

        iv = findfirst(==("VALUE"), split(ke_va["_he"], '\t'))

        for sp_ in _each(ke_va["_bo"])

            va = sp_[iv]

            if isempty(va) || va == "null"

                continue

            end

            ie = fe_ie[sp_[1]]

            vf[ie, is] = parse(Float64, va)

            if !is_[ie]

                is_[ie] = true

            end

        end

    end

    fe_[is_], map(_name_sample, ke_va__), vf[is_, :]

end

function _get_slash_slash_2(ge)

    Omics.Strin.split_get(ge, " // ", 2)

end

function _get_hgnc_map(ke_)

    Omics.Gene.ma(Omics.Table.rea(Omics.Gene.HT), ke_, Omics.Gene.HV)

end

function get_feature_map(bl_th, pl)

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

        fu = ge -> Omics.Strin.split_get(ge, " /// ", 1)

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

        hg_ge = _get_hgnc_map(["refseq_accession", "ena"])

        fu = ge -> get(hg_ge, ge, ge)

    elseif it == 9741 || it == 9742

        co = "Official Symbol"

    elseif it == 10647 || it == 21975

        co = "ENTREZ_GENE_ID"

        hg_ge = _get_hgnc_map(["entrez_id"])

        fu = ge -> get(hg_ge, ge, ge)

    elseif it == 32416

        co = "SPOT_ID"

        hg_ge = _get_hgnc_map(["entrez_id"])

        fu = ge -> get(hg_ge, ge, ge)

    elseif it == 1708 || it == 6480 || it == 10332

        co = "GENE_SYMBOL"

    elseif it == 15048

        co = "GeneSymbol"

        fu = ge -> Omics.Strin.split_get(ge, ' ', 1)

    elseif it == 16209

        co = "gene_assignment"

        fu = ge -> _get_slash_slash_2(Omics.Strin.split_get(ge, " /// ", 1))

    elseif it == 17585 || it == 17586

        co = "gene_symbols"

    elseif it == 23126

        co = "gene_assignment"

        fu = ge -> contains(ge, "AceView") ? "" : _get_slash_slash_2(ge)

    elseif it == 25336

        co = "ORF"

    elseif it == 10999 || it == 16791

        error("$pl lacks gene mapping.")

    elseif it == 13669

        co = "Description"

        fu =
            ge ->
                contains(ge, '(') ?
                ge[(findlast(==('('), ge) + 1):(findlast(==(')'), ge) - 1)] : ge

    else

        error("$pl is new.")

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

function read_process_write_plot(
    pr,
    so,
    pl = "";
    ns = "All",
    lo = false,
    nt = "",
    ps_ = (),
    pf_ = (),
)

    bl_th = rea(so)

    sa_ = get_sample(bl_th)

    ch_, vc = get_characteristic(bl_th)

    if isempty(pl)

        pl = get_platform(bl_th)

    end

    fe_, sm_, vf = get_feature(bl_th, pl)

    vc = vc[:, indexin(sm_, sa_)]

    fe_, vf = Omics.XSample.process!(fe_, vf; fe_fa = get_feature_map(bl_th, pl), lo)

    Omics.XSample.write_plot(pr, ns, sm_, ch_, vc, pl, fe_, vf, nt, ps_, pf_)

    sm_, ch_, vc, pl, fe_, vf

end

end
