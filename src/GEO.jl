module GEO

using GZip: open

using OrderedCollections: OrderedDict

using ..Omics

function make_soft(gs)

    "$(gs)_family.soft.gz"

end

function _splitting(st, de)

    (string(sp) for sp in eachsplit(st, de; limit = 2))

end

function _read(so)

    bl_th = Dict(
        "DATABASE" => OrderedDict{String, OrderedDict{String, String}}(),
        "SERIES" => OrderedDict{String, OrderedDict{String, String}}(),
        "PLATFORM" => OrderedDict{String, OrderedDict{String, String}}(),
        "SAMPLE" => OrderedDict{String, OrderedDict{String, String}}(),
    )

    bl = th = be = ""

    dk = " = "

    dc = ": "

    io = open(so)

    while !eof(io)

        li = readline(io; keep = false)

        if li[1] == '^'

            bl, th = _splitting(li[2:end], dk)

            bl_th[bl][th] = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif li == be

            bl_th[bl][th]["_co"] = readline(io; keep = false)

            bl_th[bl][th]["_ro"] = readuntil(io, "$(be[1:(end - 5)])end\n")

        else

            ke, va = _splitting(li, dk)

            if startswith(ke, "!Sample_characteristics") && contains(va, dc)

                ke, va = _splitting(va, dc)

                ke = "_ch$ke"

            end

            Omics.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    bl_th

end

function _name_sample(ke_va)

    "$(ke_va["!Sample_geo_accession"]) $(ke_va["!Sample_title"])"

end

function _get_sample(bl_th)

    sa_ = _name_sample.(values(bl_th["SAMPLE"]))

    @info "👥" sa_

    sa_

end

function _get_characteristic(bl_th)

    ke_va__ = values(bl_th["SAMPLE"])

    ch_ = String[]

    for ke_va in ke_va__

        for ke in keys(ke_va)

            if ke[1:3] == "_ch"

                push!(ch_, ke)

            end

        end

    end

    ch_ = unique!(ch_)

    cs = [get(ke_va, ch, "") for ch in ch_, ke_va in ke_va__]

    ch_ .= (ch[4:end] for ch in ch_)

    @info "🔬" ch_ cs

    ch_, cs

end

function _get_platform(bl_th)

    pl_ = collect(keys(bl_th["PLATFORM"]))

    if !isone(lastindex(pl_))

        error("There is not one platform. $pl_.")

    end

    pl = pl_[1]

    @info "🧪 $pl."

    pl

end

function _dicing(st)

    (split(sp, '\t') for sp in eachsplit(st, '\n'; keepempty = false))

end

function _get_feature(bl_th, pl)

    fe_ = [ro[1] for ro in _dicing(bl_th["PLATFORM"][pl]["_ro"])]

    # TODO: Remove.
    Omics.Error.error_duplicate(fe_)

    nf = lastindex(fe_)

    fe_id = Omics.Collection._map_index(fe_)

    se_ = falses(nf)

    ke_va__ = filter!(
        ke_va -> ke_va["!Sample_platform_id"] == pl,
        collect(values(bl_th["SAMPLE"])),
    )

    sa_ = _name_sample.(ke_va__)

    fs = fill(NaN, nf, lastindex(sa_))

    for (is, ke_va) in enumerate(ke_va__)

        iv = findfirst(==("VALUE"), split(ke_va["_co"], '\t'))

        for ro in _dicing(ke_va["_ro"])

            va = ro[iv]

            if !isempty(va)

                ie = fe_id[ro[1]]

                fs[ie, is] = va == "null" ? NaN : parse(Float64, va)

                if !se_[ie]

                    se_[ie] = true

                end

            end

        end

    end

    fe_ = fe_[se_]

    fs = fs[se_, :]

    @info "🧬 $pl $(lastindex(fe_)) / $nf" fe_ sa_ fs

    fe_, sa_, fs

end

function get_slash_slash_2(ge)

    split(ge, " // "; limit = 3)[2]

end

function _get_feature_map(bl_th, pl)

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

        ge = "Gene Symbol"

        fu = ge -> split(ge, " /// "; limit = 2)[1]

    elseif it == 5175 || it == 6244 || it == 11532 || it == 17586

        ge = "gene_assignment"

        fu = get_slash_slash_2

    elseif it == 6098 ||
           it == 6104 ||
           it == 6883 ||
           it == 6884 ||
           it == 6947 ||
           it == 10558 ||
           it == 14951

        ge = "Symbol"

    elseif it == 7567 || it == 9700 || it == 10465 || it == 16686

        ge = "GB_ACC"

        ke_va = Omics.Gene.map(("refseq_accession", "ena"))

        fu = ge -> get(ke_va, ge, ge)

    elseif it == 9741 || it == 9742

        ge = "Official Symbol"

    elseif it == 10647 || it == 21975

        ge = "ENTREZ_GENE_ID"

        ke_va = Omics.Gene.map(("entrez_id",))

        fu = ge -> get(ke_va, ge, ge)

    elseif it == 32416

        ge = "SPOT_ID"

        ke_va = Omics.Gene.map(("entrez_id",))

        fu = ge -> get(ke_va, ge, ge)

    elseif it == 1708 || it == 6480 || it == 10332

        ge = "GENE_SYMBOL"

    elseif it == 15048

        ge = "GeneSymbol"

        fu = ge -> split(ge; limit = 2)[1]

    elseif it == 16209

        ge = "gene_assignment"

        fu = ge -> get_slash_slash_2(split(ge, " /// "; limit = 2)[1])

    elseif it == 17585 || it == 17586

        ge = "gene_symbols"

    elseif it == 23126

        ge = "gene_assignment"

        fu = ge -> contains(ge, "AceView") ? "" : get_slash_slash_2(ge)

    elseif it == 25336

        ge = "ORF"

    elseif it == 10999 || it == 16791

        error("\"$pl\" lacks gene mapping.")

    elseif it == 13669

        ge = "Description"

        fu =
            ge ->
                contains(ge, '(') ?
                ge[(findlast(==('('), ge) + 1):(findlast(==(')'), ge) - 1)] : ge

    else

        error("\"$pl\" is new.")

    end

    fe_ge = Dict{String, String}()

    ig = findfirst(==(ge), split(bl_th["PLATFORM"][pl]["_co"], '\t'))

    for ro in _dicing(bl_th["PLATFORM"][pl]["_ro"])

        ge = ro[ig]

        if !Omics.String.is_bad(ge)

            fe_ge[ro[1]] = fu(ge)

        end

    end

    fe_ge

end

function ge(so)

    bl_th = _read(so)

    sa_ = _get_sample(bl_th)

    ir_, ia = _get_characteristic(bl_th)

    bl_th, sa_, ir_, ia

end

function ge(ou, so, pl = ""; ns = "All", lo = false, ir = "", ps_ = (), pf_ = ())

    bl_th, sa_, ir_, ia = ge(so)

    if isempty(pl)

        pl = _get_platform(bl_th)

    end

    fe_, sf_, fs = _get_feature(bl_th, pl)

    is = ia[:, indexin(sf_, sa_)]

    fe_, fs = XSample.rename_collapse_log(fe_, fs; fe_f2 = _get_feature_map(bl_th, pl), lo)

    XSample.write(ou, ns, sf_, ir_, is, pl, fe_, fs, ir, ps_, pf_)

end

end
