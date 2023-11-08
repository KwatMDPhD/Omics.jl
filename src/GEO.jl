module GEO

using Downloads: download

using GZip: open

using OrderedCollections: OrderedDict

using ..Nucleus

const KE = "!Sample_title"

function establish(di, gs)

    Nucleus.Error.error_missing(di)

    na = "$(gs)_family.soft.gz"

    pa = joinpath(di, na)

    if !isfile(pa)

        download.(
            "ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(view(gs, 1:(lastindex(gs) - 3)))nnn/$gs/soft/$na",
            pa,
        )

    end

    pa

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

    bl = th = be = ""

    io = open(gz)

    dek = " = "

    dec = ": "

    while !eof(io)

        li = readline(io; keep = false)

        if li[1] == '^'

            bl, th = _split(view(li, 2:lastindex(li)), dek)

            bl_th[bl][th] = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif li == be

            # TODO: Understand why `view` is slower.
            #ta = readuntil(io, "$(view(be, 1:(lastindex(be) - 5)))end\n")
            ta = readuntil(io, "$(be[1:(end - 5)])end\n")

            n_ro = count('\n', ta)

            n_rok = 1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            if n_ro == n_rok

                bl_th[bl][th]["_ta"] = ta

            else

                @warn "\"$th\" table's numbers of rows differ. $n_ro != $n_rok."

            end

        else

            ke, va = _split(li, dek)

            if startswith(ke, "!Sample_characteristics")

                if contains(va, dec)

                    pr, va = _split(va, dec)

                    ke = "_ch.$pr"

                else

                    @warn "\"$va\" lacks \"$dec\"."

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

    ch_ = String[]

    ke_va__ = values(sa_ke_va)

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

    # TODO: Check.
    if it == 96 || it == 97 || it == 570 || it == 13667 || it == 15207

        co = "Gene Symbol"

        fu = fe -> Nucleus.String.split_get(fe, " /// ", 1)

    elseif it == 5175 || it == 6244 || it == 11532 || it == 17586 || it == 23126

        co = "gene_assignment"

        fu = fe -> Nucleus.String.split_get(fe, " // ", 2)

    elseif it == 6098 || it == 6884 || it == 6947 || it == 10558 || it == 14951

        co = "Symbol"

    elseif it == 10332

        co = "GENE_SYMBOL"

    elseif it == 15048

        co = "GeneSymbol"

        fu = fe -> Nucleus.String.split_get(fe, ' ', 1)

    elseif it == 16209

        co = "gene_assignment"

        fu = fe -> Nucleus.String.split_get(Nucleus.String.split_get(fe, " /// ", 1), " // ", 2)

    elseif it == 16686

        co = "GB_ACC"

    elseif it == 25336

        co = "ORF"

    else

        error("\"$pl\" is new.")

    end

    li_ = _dice(ta)

    n_li = lastindex(li_)

    n_fe = n_li - 1

    fe_id = Dict{String, Int}()

    # TODO: Understand why `String[]` is faster.
    fe2_ = Vector{String}(undef, n_fe)

    id2 = findfirst(==(co), li_[1])

    for (id, li) in enumerate(view(li_, 2:n_li))

        fe = li[1]

        fe_id[fe] = id

        fe2 = li[id2]

        if Nucleus.String.is_bad(fe2)

            fe2_[id] = "_$fe"

        else

            # TODO: Benchmark variable collision.
            fe2 = fu(fe2)

            if Nucleus.String.is_bad(fe2)

                fe2_[id] = "_$fe"

            else

                fe2_[id] = fe2

            end

        end

    end

    n_fe, fe_id, fe2_

end

function _error_table(th, ke_va)

    if !haskey(ke_va, "_ta")

        error("\"$th\" lacks a table.")

    end

end

function tabulate(ke_va, sa_ke_va)

    pl = ke_va["!Platform_geo_accession"]

    _error_table(pl, ke_va)

    n_fe, fe_id, fe2_ = _map_feature(pl, ke_va["_ta"])

    n_sa = length(sa_ke_va)

    sa_ = Vector{String}(undef, n_sa)

    fe_x_sa_x_fl = Matrix{Float64}(undef, n_fe, n_sa)

    isf_ = falses(n_fe)

    iss_ = BitVector(undef, n_sa)

    for (ids, (sa, ke_va)) in enumerate(sa_ke_va)

        _error_table(sa, ke_va)

        if ke_va["!Sample_platform_id"] == pl

            li_ = _dice(ke_va["_ta"])

            id2 = findfirst(==("VALUE"), li_[1])

            for li in view(li_, 2:lastindex(li_))

                va = li[id2]

                if !isempty(va)

                    idf = fe_id[li[1]]

                    fe_x_sa_x_fl[idf, ids] = parse(Float64, va)

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

    fe2_[isf_], iss_, fe_x_sa_x_fl[isf_, iss_]

end

function write(
    di,
    gs;
    ke = KE,
    pl = "",
    sas = nothing,
    saf = nothing,
    chf = nothing,
    nas = "Sample",
    ch = "",
    ke_ar...,
)

    bl_th = read(establish(di, gs))

    sa_ke_va = bl_th["SAMPLE"]

    sa_ = get_sample(sa_ke_va, ke)

    @info "💃 Sample" sa_

    ch_, ch_x_sa_x_st = tabulate(sa_ke_va)

    @info "👙 Characteristic" ch_ ch_x_sa_x_st

    if isempty(pl)

        pl_ = collect(keys(bl_th["PLATFORM"]))

        if !isone(lastindex(pl_))

            error("There is not one platform. $pl_.")

        end

        pl = pl_[1]

    end

    fe_, is_, fe_x_sa_x_nu = tabulate(bl_th["PLATFORM"][pl], sa_ke_va)

    saf_ = sa_[is_]

    @info "🧬 $pl" fe_ saf_ fe_x_sa_x_nu

    if sa_ != saf_

        sa_, ch_x_sa_x_st, fe_x_sa_x_nu =
            Nucleus.FeatureXSample.intersect_column(sa_, saf_, ch_x_sa_x_st, fe_x_sa_x_nu)

    end

    if !isnothing(sas)

        if sas isa String

            is_ = contains.(sa_, sas)

        elseif sas isa Tuple{String, String}

            is_ = ch_x_sa_x_st[findfirst(==(sas[1]), ch_), :] .== sas[2]

        end

        sa_ = sa_[is_]

        ch_x_sa_x_st = ch_x_sa_x_st[:, is_]

        fe_x_sa_x_nu = fe_x_sa_x_nu[:, is_]

        @info "🏩 Selected" sa_

    end

    # TODO: Benchmark `.`.

    if !isnothing(saf)

        sa_ .= saf.(sa_)

    end

    if !isnothing(chf)

        ch_x_sa_x_st .= chf.(ch_x_sa_x_st)

    end

    fe_, fe_x_sa_x_nu =
        Nucleus.FeatureXSample.transform(fe_, sa_, fe_x_sa_x_nu; nar = pl, nac = nas, ke_ar...)

    nasc = Nucleus.Path.clean(nas)

    Nucleus.DataFrame.write(
        joinpath(di, "characteristic_x_$(nasc)_x_string.tsv"),
        "Characteristic",
        ch_,
        sa_,
        ch_x_sa_x_st,
    )

    Nucleus.FeatureXSample.count_unique(ch_, eachrow(ch_x_sa_x_st))

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

    sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_nu

end

end
