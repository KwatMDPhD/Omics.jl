module GEO

using Downloads: download as downloads_download

using GZip: open

using OrderedCollections: OrderedDict

using ..Nucleus

const KE = "!Sample_title"

function download(di, gs)

    Nucleus.Error.error_missing(di)

    gz = "$(gs)_family.soft.gz"

    downloads_download.(
        "ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(view(gs, 1:(lastindex(gs) - 3)))nnn/$gs/soft/$gz",
        joinpath(di, gz),
    )

end

function _split(st, de)

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

        if li[1] == '^'

            bl, th = _split(view(li, 2:lastindex(li)), de1)

            bl_th[bl][th] = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif li == be

            # TODO: Understand why `view` is slower.
            #ta = readuntil(io, "$(view(be, 1:(lastindex(be) - 5)))end\n")
            ta = readuntil(io, "$(be[1:(end - 5)])end\n")

            n_ro = count('\n', ta)

            n_rod = 1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            if n_ro == n_rod

                bl_th[bl][th]["_ta"] = ta

            else

                @warn "\"$th\" table's numbers of rows differ. $n_ro != $n_rod."

            end

        else

            ke, va = _split(li, de1)

            if startswith(ke, "!Sample_characteristics")

                if contains(va, de2)

                    pr, va = _split(va, de2)

                    ke = "_ch.$pr"

                else

                    @warn "\"$va\" lacks \"$de2\"."

                end

            end

            Nucleus.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    pl_ = keys(bl_th["PLATFORM"])

    if !isone(length(pl_))

        @warn "There is not one platform. $pl_."

    end

    bl_th

end

function get_sample(sa_ke_va, ke = KE)

    [ke_va[ke] for ke_va in values(sa_ke_va)]

end

function tabulate(sa_ke_va)

    ke_va__ = values(sa_ke_va)

    ch_ = String[]

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

        ch_[id] = titlecase(view(ch, 5:lastindex(ch)))

    end

    ch_, ch_x_sa_x_st

end

function _dice(ta)

    split.(eachsplit(ta, '\n'; keepempty = false), '\t')

end

function _map_feature(pl, ta)

    it = parse(Int, view(pl, 4:lastindex(pl)))

    co = ""

    fu = identity

    if it == 96 || it == 97 || it == 570 || it == 13667

        co = "Gene Symbol"

        fu = fe -> Nucleus.String.split_get(fe, " /// ", 1)

    elseif it == 5175 || it == 6244 || it == 11532 || it == 17586

        co = "gene_assignment"

        fu = fe -> Nucleus.String.split_get(fe, " // ", 2)

    elseif it == 6098 || it == 6884 || it == 6947 || it == 10558 || it == 14951

        co = "Symbol"

    elseif it == 10332

        co = "GENE_SYMBOL"

    elseif it == 15048

        co = "GeneSymbol"

        fu = fe -> Nucleus.String.split_get(fe, ' ', 1)

    elseif it == 16686

        co = "GB_ACC"

    else

        error("\"$pl\" is new.")

    end

    li_ = _dice(ta)

    he = li_[1]

    idi = findfirst(==("ID"), he)
    @assert isone(idi)

    idc = findfirst(==(co), he)

    n_li = lastindex(li_)

    n_fe = n_li - 1

    fe_id = Dict{String, Int}()

    # TODO: Understand why `String[]` is faster.
    fec_ = Vector{String}(undef, n_fe)

    for (id, li) in enumerate(view(li_, 2:n_li))

        fe = li[idi]

        fec = li[idc]

        fe_id[fe] = id

        fec_[id] = Nucleus.String.is_bad(fec) ? "_$fe" : fu(fec)

    end

    n_fe, fe_id, fec_

end

function tabulate(ke_va, sa_ke_va)

    pl = ke_va["!Platform_geo_accession"]

    if !haskey(ke_va, "_ta")

        error("\"$pl\" lacks a table.")

    end

    n_fe, fe_id, fec_ = _map_feature(pl, ke_va["_ta"])

    n_sa = length(sa_ke_va)

    sa_ = Vector{String}(undef, n_sa)

    fe_x_sa_x_fl = Matrix{Float64}(undef, n_fe, n_sa)

    isf_ = falses(n_fe)

    iss_ = BitVector(undef, n_sa)

    for (ids, (sa, ke_va)) in enumerate(sa_ke_va)

        if !haskey(ke_va, "_ta")

            error("\"$sa\" lacks a table.")

        end

        if ke_va["!Sample_platform_id"] == pl

            li_ = _dice(ke_va["_ta"])

            idv = findfirst(==("VALUE"), li_[1])

            for li in view(li_, 2:lastindex(li_))

                st = li[idv]

                if !isempty(st)

                    idf = fe_id[li[1]]

                    fe_x_sa_x_fl[idf, ids] = parse(Float64, st)

                    isf_[idf] = true

                end

            end

            sa_[ids] = sa

            is = true

        else

            is = false

        end

        iss_[ids] = is

    end

    fec_[isf_], iss_, fe_x_sa_x_fl[isf_, iss_]

end

function write(
    di,
    gs,
    pl = "";
    ke = KE,
    ur = "",
    sas_ = (),
    sar_ = (),
    chr_ = (),
    fe_fe2 = Dict{String, String}(),
    lo = false,
    nas = "Sample",
    ch = "",
)

    Nucleus.Error.error_missing(di)

    di = Nucleus.Path.establish(joinpath(di, lowercase(gs)))

    gz = joinpath(di, "$(gs)_family.soft.gz")

    if !isfile(gz)

        download(di, gs)

    end

    bl_th = read(gz)

    sa_ke_va = bl_th["SAMPLE"]

    sa_ = get_sample(sa_ke_va, ke)

    @info "👯‍♀️ Sample" sa_

    ch_, ch_x_sa_x_st = tabulate(sa_ke_va)

    @info "👙 Characteristic" ch_ ch_x_sa_x_st

    if isempty(ur)

        if isempty(pl)

            pl_ = collect(keys(bl_th["PLATFORM"]))

            if !isone(lastindex(pl_))

                error("There is not one platform. $pl_.")

            end

            pl = pl_[1]

        end

        fe_, is_, fe_x_sa_x_nu = tabulate(bl_th["PLATFORM"][pl], sa_ke_va)

        saf_ = sa_[is_]

    else

        gz = joinpath(di, "$gs.tsv.gz")

        if !isfile(gz)

            download(ur, gz)

        end

        pl = "Feature"

        _naf, fe_, saf_, fe_x_sa_x_nu = Nucleus.DataFrame.separate(gz)

    end

    @info "🧬 Feature" fe_ saf_ fe_x_sa_x_nu

    if sa_ != saf_

        sa_, ch_x_sa_x_st, fe_x_sa_x_nu =
            Nucleus.FeatureXSample.match(sa_, saf_, ch_x_sa_x_st, fe_x_sa_x_nu)

    end

    if !isempty(sas_)

        is_ = (sa -> all(occursin(sa), sas_)).(sa_)

        sa_ = sa_[is_]

        ch_x_sa_x_st = ch_x_sa_x_st[:, is_]

        fe_x_sa_x_nu = fe_x_sa_x_nu[:, is_]

        @info "🏩 Selected sample" sa_

    end

    if !isempty(sar_)

        sa_ = replace.(sa_, sar_...)

    end

    if !isempty(chr_)

        replace!(ch_x_sa_x_st, chr_...)

    end

    fe_, fe_x_sa_x_nu =
        Nucleus.FeatureXSample.transform(di, fe_, sa_, fe_x_sa_x_nu; fe_fe2, lo, naf = pl, nas)

    nasc = Nucleus.Path.clean(nas)

    Nucleus.DataFrame.write(
        joinpath(di, "characteristic_x_$(nasc)_x_string.tsv"),
        "Characteristic",
        ch_,
        sa_,
        ch_x_sa_x_st,
    )

    Nucleus.FeatureXSample.summarize(ch_, eachrow(ch_x_sa_x_st))

    pr = joinpath(di, "$(lowercase(pl))_x_$(nasc)_x_number")

    Nucleus.DataFrame.write("$pr.tsv", pl, fe_, sa_, fe_x_sa_x_nu)

    if isempty(ch)

        grc_ = Int[]

        title_text = gs

    else

        grc_ = ch_x_sa_x_st[findfirst(==(ch), ch_), :]

        title_text = "$gs (by $(titlecase(ch)))"

    end

    Nucleus.Plot.plot_heat_map(
        "$pr.html",
        fe_x_sa_x_nu;
        y = fe_,
        x = sa_,
        nar = pl,
        nac = nas,
        grc_,
        layout = Dict("title" => Dict("text" => title_text)),
    )

    di, sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_nu

end

end
