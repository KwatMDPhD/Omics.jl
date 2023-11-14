module GEO

using GZip: open

using OrderedCollections: OrderedDict

using ..Nucleus

const KE = "!Sample_title"

function _split(st, de)

    (string(st) for st in eachsplit(st, de; limit = 2))

end

function _read(gz)

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

            ta = readuntil(io, "$(be[1:(end - 5)])end\n")
            @assert count('\n', ta) ==
                    1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            bl_th[bl][th]["_ta"] = ta

        else

            ke, va = _split(li, dek)

            if startswith(ke, "!Sample_characteristics") && contains(va, dec)

                ch, va = _split(va, dec)

                ke = "_ch.$ch"

            end

            Nucleus.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    bl_th

end

function _get_sample(bl_th, ke = KE)

    sa_ = [ke_va[ke] for ke_va in values(bl_th["SAMPLE"])]

    @info "💃 Sample" sa_

    sa_

end

function _get_characteristic(bl_th)

    ch_ = String[]

    ke_va__ = values(bl_th["SAMPLE"])

    for ke_va in ke_va__

        for ke in keys(ke_va)

            if startswith(ke, "_ch")

                push!(ch_, ke)

            end

        end

    end

    ch_ = sort!(unique!(ch_))

    ch_x_sa_x_st = [Base.get(ke_va, ch, "") for ch in ch_, ke_va in ke_va__]

    ch_ .= (ch -> titlecase(view(ch, 5:lastindex(ch)))).(ch_)

    @info "👙 Characteristic" ch_ ch_x_sa_x_st

    ch_, ch_x_sa_x_st

end

function _dice(ta)

    split.(eachsplit(ta, '\n'; keepempty = false), '\t')

end

function _get_platform(bl_th)

    pl_ = collect(keys(bl_th["PLATFORM"]))

    if !isone(lastindex(pl_))

        error("There is not one platform. $pl_.")

    end

    pl_[1]

end

function _get_feature_map(bl_th, pl)

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

    li_ = _dice(bl_th["PLATFORM"][pl]["_ta"])

    an_id = Dict{String, Int}()

    # TODO: Understand why `Vector{String}(undef, n_fe)` is slower.
    fe_ = String[]

    idc = findfirst(==(co), li_[1])

    for (id, li) in enumerate(view(li_, 2:lastindex(li_)))

        an = li[1]

        an_id[an] = id

        fe = li[idc]

        if Nucleus.String.is_bad(fe)

            fe = "_$an"

        else

            fe = fu(fe)

            if Nucleus.String.is_bad(fe)

                fe = "_$an"

            end

        end

        push!(fe_, fe)

    end

    an_id, fe_

end

function _get_feature(bl_th, pl)

    an_id, fe_ = _get_feature_map(bl_th, pl)

    sa_ke_va = bl_th["SAMPLE"]

    n_fe = lastindex(fe_)

    n_sa = length(sa_ke_va)

    fe_x_sa_x_fl = Matrix{Float64}(undef, n_fe, n_sa)

    isf_ = falses(n_fe)

    iss_ = falses(n_sa)

    idv = nothing

    for (ids, ke_va) in enumerate(values(sa_ke_va))

        if ke_va["!Sample_platform_id"] != pl

            continue

        end

        li_ = _dice(ke_va["_ta"])

        if isnothing(idv)

            idv = findfirst(==("VALUE"), li_[1])

        end

        for li in view(li_, 2:lastindex(li_))

            va = li[idv]

            if isempty(va)

                continue

            end

            idf = an_id[li[1]]

            fe_x_sa_x_fl[idf, ids] = parse(Float64, va)

            isf_[idf] = true

        end

        iss_[ids] = true

    end

    fe_ = fe_[isf_]

    fe_x_sa_x_fl = fe_x_sa_x_fl[isf_, iss_]

    @info "🧬 $pl" fe_ sum(iss_) / lastindex(iss_) fe_x_sa_x_fl

    fe_, iss_, fe_x_sa_x_fl

end

function get_sample_characteristic(so)

    bl_th = _read(so)

    sa_ = _get_sample(bl_th)

    ch_, ch_x_sa_x_st = _get_characteristic(bl_th)

    bl_th, sa_, ch_, ch_x_sa_x_st

end

function intersect(co1_, co2_, ma1, ma2)

    it_ = Base.intersect(co1_, co2_)

    Nucleus.FeatureXSample.log_intersection((co1_, co2_), it_)

    it_, ma1[:, indexin(it_, co1_)], ma2[:, indexin(it_, co2_)]

end

function select(is_, co_, ma1, ma2)

    co_ = co_[is_]

    @info "🏩 Selected from $(lastindex(is_))" co_

    co_, ma1[:, is_], ma2[:, is_]

end

function write(ou, sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_nu, pl, nas, nan, ch)

    nasc = Nucleus.Path.clean(nas)

    Nucleus.DataFrame.write(
        joinpath(ou, "characteristic_x_$(nasc)_x_string.tsv"),
        "Characteristic",
        ch_,
        sa_,
        ch_x_sa_x_st,
    )

    Nucleus.FeatureXSample.count_unique(ch_, eachrow(ch_x_sa_x_st))

    pr = joinpath(ou, "$(lowercase(pl))_x_$(nasc)_x_number")

    Nucleus.DataFrame.write("$pr.tsv", pl, fe_, sa_, fe_x_sa_x_nu)

    if isempty(ch)

        grc_ = Int[]

        title_text = nan

    else

        grc_ = ch_x_sa_x_st[findfirst(==(ch), ch_), :]

        title_text = "$nan (by $(titlecase(ch)))"

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

end

function get(so, ch; pl = "", se = nothing, lo = false, nas = "Sample")

    bl_th, sa_, ch_, ch_x_sa_x_st = get_sample_characteristic(so)

    if isempty(pl)

        pl = _get_platform(bl_th)

    end

    fe_, is_, fe_x_sa_x_fl = _get_feature(bl_th, pl)

    saf_ = sa_[is_]

    if sa_ != saf_

        sa_, ch_x_sa_x_st, fe_x_sa_x_fl = intersect(sa_, saf_, ch_x_sa_x_st, fe_x_sa_x_fl)

    end

    if !isnothing(se)

        if typeof(se) == String

            is_ = contains.(sa_, se)

        else

            is_ = ch_x_sa_x_st[findfirst(==(se[1]), ch_), :] .== se[2]

        end

        sa_, ch_x_sa_x_st, fe_x_sa_x_fl = select(is_, sa_, ch_x_sa_x_st, fe_x_sa_x_fl)

    end

    ou, na = splitdir(so)

    nan = view(na, 1:(lastindex(na) - 15))

    fe_, fe_x_sa_x_fl =
        Nucleus.FeatureXSample.transform(fe_, sa_, fe_x_sa_x_fl; lo, nar = pl, nac = nas, nan)

    write(ou, sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_fl, pl, nas, nan, ch)

    sa_, ch_, ch_x_sa_x_st, fe_, fe_x_sa_x_fl

end

end
