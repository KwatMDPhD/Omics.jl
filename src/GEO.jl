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

        if startswith(li, '^')

            bl, th = eachsplit(li[2:end], de; limit = 2)

            bl_th[bl][th] = ke_va = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif li == be

            ke_va["he"] = readline(io; keep = false)

            ke_va["bo"] = readuntil(io, "$(be[1:(end - 5)])end\n")

        else

            ke, va = eachsplit(li, de; limit = 2)

            if startswith(ke, "!Sample_characteristics") && contains(va, dc)

                ch, va = eachsplit(va, dc; limit = 2)

                ke = "ch$ch"

            end

            Omics.Dic.set_with_suffix!(ke_va, ke, va)

        end

    end

    close(io)

    bl_th

end

function get_characteristic(bl_th)

    ke_va__ = values(bl_th["SAMPLE"])

    ch_ = String[]

    for ke_va in ke_va__, ke in keys(ke_va)

        if startswith(ke, "ch")

            push!(ch_, ke)

        end

    end

    vc = [get(ke_va, ch, "") for ch in unique!(ch_), ke_va in ke_va__]

    map!(ch -> ch[3:end], ch_, ch_), vc

end

function _each(bo)

    (split(li, '\t') for li in eachsplit(bo, '\n'; keepempty = false))

end

function _name_sample(ke_va)

    "$(ke_va["!Sample_geo_accession"]) $(ke_va["!Sample_title"])"

end

function get_feature(bl_th, pl)

    fe_ = map(sp_ -> sp_[1], _each(bl_th["PLATFORM"][pl]["bo"]))

    ke_va__ = filter!(
        ke_va -> ke_va["!Sample_platform_id"] == pl,
        collect(values(bl_th["SAMPLE"])),
    )

    uf = lastindex(fe_)

    vf = fill(NaN, uf, length(ke_va__))

    se_ = falses(uf)

    fe_ie = Dict(fe => ie for (ie, fe) in enumerate(fe_))

    for is in eachindex(ke_va__)

        ke_va = ke_va__[is]

        iv = findfirst(==("VALUE"), split(ke_va["he"], '\t'))

        for sp_ in _each(ke_va["bo"])

            va = sp_[iv]

            if isempty(va) || va == "null"

                continue

            end

            ie = fe_ie[sp_[1]]

            vf[ie, is] = parse(Float64, va)

            if !se_[ie]

                se_[ie] = true

            end

        end

    end

    fe_[se_], map(_name_sample, ke_va__), vf[se_, :]

end

function _get_slash_slash_2(fe)

    Omics.Strin.ge(fe, 2, " // ")

end

function ma(bl_th, pl)

    id = parse(Int, pl[4:end])

    fu = identity

    if id == 96 ||
       id == 97 ||
       id == 570 ||
       id == 571 ||
       id == 3921 ||
       id == 4685 ||
       id == 13158 ||
       id == 13667 ||
       id == 15207

        co = "Gene Symbol"

        fu = fe -> Omics.Strin.get_1(fe, " /// ")

    elseif id == 5175 || id == 6244 || id == 11532 || id == 17586

        co = "gene_assignment"

        fu = _get_slash_slash_2

    elseif id == 6098 ||
           id == 6104 ||
           id == 6883 ||
           id == 6884 ||
           id == 6947 ||
           id == 10558 ||
           id == 14951

        co = "Symbol"

    elseif id == 7567 || id == 9700 || id == 10465 || id == 16686

        co = "GB_ACC"

        hg_ge = Omics.Gene.map_hgnc(["refseq_accession", "ena"])

        fu = fe -> get(hg_ge, fe, fe)

    elseif id == 9741 || id == 9742

        co = "Official Symbol"

    elseif id == 10647 || id == 21975

        co = "ENTREZ_GENE_ID"

        hg_ge = Omics.Gene.map_hgnc(["entrez_id"])

        fu = fe -> get(hg_ge, fe, fe)

    elseif id == 32416

        co = "SPOT_ID"

        hg_ge = Omics.Gene.map_hgnc(["entrez_id"])

        fu = fe -> get(hg_ge, fe, fe)

    elseif id == 1708 || id == 6480 || id == 10332 || id == 17077

        co = "GENE_SYMBOL"

    elseif id == 15048

        co = "GeneSymbol"

        fu = fe -> Omics.Strin.get_1(fe)

    elseif id == 16209

        co = "gene_assignment"

        fu = fe -> _get_slash_slash_2(Omics.Strin.get_1(fe, " /// "))

    elseif id == 17585 || id == 17586

        co = "gene_symbols"

    elseif id == 23126

        co = "gene_assignment"

        fu = fe -> contains(fe, "AceView") ? "" : _get_slash_slash_2(fe)

    elseif id == 25336

        co = "ORF"

    elseif id == 10999 || id == 16791

        error("$pl lacks gene mapping.")

    elseif id == 13669

        co = "Description"

        fu =
            fe ->
                contains(fe, '(') ?
                fe[(findlast(==('('), fe) + 1):(findlast(==(')'), fe) - 1)] : fe

    else

        error("$pl is new.")

    end

    fe_ge = Dict{String, String}()

    ic = findfirst(==(co), split(bl_th["PLATFORM"][pl]["he"], '\t'))

    for sp_ in _each(bl_th["PLATFORM"][pl]["bo"])

        fe = sp_[ic]

        if !Omics.Strin.is_bad(fe)

            fe_ge[sp_[1]] = fu(fe)

        end

    end

    fe_ge

end

function get_sample_character(so)

    bl_th = rea(so)

    bl_th, map(_name_sample, values(bl_th["SAMPLE"])), get_characteristic(bl_th)...

end

function read_process_write_plot(
    di,
    so,
    pl = "";
    ns = "All",
    lo = false,
    nt = "",
    ps_ = (),
    pf_ = (),
)

    bl_th, sc_, ch_, vc = get_sample_character(so)

    if isempty(pl)

        pl = collect(keys(bl_th["PLATFORM"]))[]

    end

    fe_, sf_, vf = get_feature(bl_th, pl)

    vc = vc[:, indexin(sf_, sc_)]

    fe_, vf = Omics.XSample.process(fe_, vf; f1_f2 = ma(bl_th, pl), lo)

    Omics.XSample.writ(di, ns, sf_, ch_, vc, pl, fe_, vf, nt, ps_, pf_)

    sf_, ch_, vc, pl, fe_, vf

end

function get_gpl_1_2(di, so, p1, p2; ke_ar...)

    s1_, c1_, h1, _, f1_, e1 = read_process_write_plot(di, so, p1; ns = p1, ke_ar...)

    s2_, c2_, h2, _, f2_, e2 = read_process_write_plot(di, so, p2; ns = p2, ke_ar...)

    @assert c1_ == c2_

    @assert h1 == h2

    rm(joinpath(di, "$p1.json"))

    rm(joinpath(di, "$p2.json"))

    fu = sa -> trim_1(trim_end(sa))

    sa_ = map(fu, s1_)

    @assert sa_ == map(fu, s2_)

    map(id -> "$(get_1(s1_[id]))$(get_1(s2_[id])) $(sa_[id])", eachindex(s1_)),
    c1_,
    h1,
    "$p1$p2",
    Omics.XSample.process(vcat(f1_, f2_), vcat(e1, e2))...

end

function read_raw(ra, cf, cv; ke_ar...)

    f1_ = String[]

    sa_ = String[]

    vf___ = Vector{Float64}[]

    for gz in readdir(ra)

        push!(sa_, gz[1:(end - 7)])

        ta = Omics.Table.rea(joinpath(ra, gz); ke_ar...)

        f2_ = ta[!, cf]

        if isempty(f1_)

            f1_ = f2_

        end

        @assert f1_ == f2_

        push!(vf___, ta[!, cv])

    end

    f1_, sa_, hcat(vf___...)

end

end
