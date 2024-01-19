module GEO

using GZip: open

using OrderedCollections: OrderedDict

using ..Nucleus

function make_soft(gs)

    "$(gs)_family.soft.gz"

end

# TODO: Consider removing.
function _split(st, de)

    (string(st) for st in eachsplit(st, de; limit = 2))

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

            bl, th = _split(view(li, 2:lastindex(li)), dk)

            bl_th[bl][th] = OrderedDict{String, String}()

            be = "!$(lowercase(bl))_table_begin"

        elseif li == be

            ta = readuntil(io, "$(be[1:(end - 5)])end\n")

            @assert count('\n', ta) ==
                    1 + parse(Int, bl_th[bl][th]["!$(titlecase(bl))_data_row_count"])

            bl_th[bl][th]["_ta"] = ta

        else

            ke, va = _split(li, dk)

            if startswith(ke, "!Sample_characteristics") && contains(va, dc)

                ke, va = _split(va, dc)

                ke = "_ch$ke"

            end

            Nucleus.Dict.set_with_suffix!(bl_th[bl][th], ke, va)

        end

    end

    close(io)

    bl_th

end

function _get_sample(bl_th)

    sa_ = [
        "$(ke_va["!Sample_geo_accession"])_$(ke_va["!Sample_title"])" for
        ke_va in values(bl_th["SAMPLE"])
    ]

    @info "💃 Sample" sa_

    sa_

end

function _get_characteristic(bl_th)

    ke_va__ = values(bl_th["SAMPLE"])

    ch_ = String[]

    for ke_va in ke_va__

        for ke in keys(ke_va)

            if ke == "!Sample_platform_id" || view(ke, 1:3) == "_ch"

                push!(ch_, ke)

            end

        end

    end

    ch_ = sort!(unique!(ch_))

    mc = [Base.get(ke_va, ch, "") for ch in ch_, ke_va in ke_va__]

    for (i1, ch) in enumerate(ch_)

        ch_[i1] = ch == "!Sample_platform_id" ? "Platform" : titlecase(view(ch, 4:lastindex(ch)))

    end

    @info "👙 Characteristic" ch_ mc

    ch_, mc

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

    ro_ = _dice(bl_th["PLATFORM"][pl]["_ta"])

    st_i1 = Dict{String, Int}()

    i2 = Nucleus.Collection.find(co, ro_[1])

    # TODO: Understand why `Vector{String}(undef, n1)` is slower.
    fe_ = String[]

    for (i1, ro) in enumerate(view(ro_, 2:lastindex(ro_)))

        st_i1[ro[1]] = i1

        fe = ro[i2]

        if !Nucleus.String.is_bad(fe)

            fe = fu(fe)

        end

        push!(fe_, fe)

    end

    st_i1, fe_

end

function _get_feature(bl_th, pl)

    st_i1, fe_ = _get_feature_map(bl_th, pl)

    sa_di = bl_th["SAMPLE"]

    n1 = lastindex(fe_)

    n2 = length(sa_di)

    mf = Matrix{Float64}(undef, n1, n2)

    i1_ = falses(n1)

    i2_ = falses(n2)

    co = "VALUE"

    iv = nothing

    for (i2, ke_va) in enumerate(values(sa_di))

        if ke_va["!Sample_platform_id"] != pl

            continue

        end

        i2_[i2] = true

        ro_ = _dice(ke_va["_ta"])

        co_ = ro_[1]

        if isnothing(iv)

            iv = Nucleus.Collection.find(co, co_)

        else

            @assert iv == Nucleus.Collection.find(co, co_)

        end

        for ro in view(ro_, 2:lastindex(ro_))

            st = ro[1]

            i1 = st_i1[st]

            va = ro[iv]

            if Nucleus.String.is_bad(fe_[i1]) || isempty(va)

                continue

            end

            i1_[i1] = true

            mf[i1, i2] = parse(Float64, va)

        end

    end

    fe_ = fe_[i1_]

    mf = mf[i1_, i2_]

    @info "🧬 $pl" sum(i1_) / lastindex(i1_) sum(i2_) / lastindex(i2_) fe_ mf

    fe_, i2_, mf

end

function get_sample_characteristic(so)

    bl_th = _read(so)

    bl_th, _get_sample(bl_th), _get_characteristic(bl_th)...

end

function intersect(c1_, c2_, m1, m2)

    it_ = Base.intersect(c1_, c2_)

    Nucleus.FeatureXSample.log_intersection((c1_, c2_), it_)

    it_, m1[:, indexin(it_, c1_)], m2[:, indexin(it_, c2_)]

end

function select(i2_, co_, m1, m2)

    co_ = co_[i2_]

    @info "🏩 Selected from $(lastindex(i2_))" co_

    co_, m1[:, i2_], m2[:, i2_]

end

# TODO: Generalize and test.
function write(ou, ns, sa_, ch_, mc, pl, fe_, nn, mf, ch)

    nc = Nucleus.Path.clean(ns)

    # TODO: Try `replace!`.
    sa_ = replace.(sa_, ',' => '_')

    Nucleus.DataFrame.write(
        joinpath(ou, "characteristic_x_$(nc)_x_string.tsv"),
        "Characteristic",
        ch_,
        sa_,
        mc,
    )

    Nucleus.FeatureXSample.count_unique(ch_, eachrow(mc))

    Nucleus.FeatureXSample.write_plot(
        joinpath(ou, "$(lowercase(pl))_x_$(nc)_x_number"),
        pl,
        fe_,
        ns,
        sa_,
        nn,
        mf;
        gc_ = isempty(ch) ? Int[] : mc[Nucleus.Collection.find(ch, ch_), :],
    )

end

function get(ou, so; ns = "Sample", ss = nothing, sc_ = (), ch = "", pl = "", lo = false)

    bl_th, sa_, ch_, mc = get_sample_characteristic(so)

    if isempty(pl)

        pl = _get_platform(bl_th)

    end

    fe_, i2_, mf = _get_feature(bl_th, pl)

    sf_ = sa_[i2_]

    if sa_ != sf_

        sa_, mc, mf = intersect(sa_, sf_, mc, mf)

    end

    if !isnothing(ss)

        sa_, mc, mf = select(contains.(sa_, ss), sa_, mc, mf)

    end

    if !isempty(sc_)

        sa_, mc, mf = select(mc[Nucleus.Collection.find(sc_[1], ch_), :] .== sc_[2], sa_, mc, mf)

    end

    nn = basename(so)[1:(end - 15)]

    fe_, mf = Nucleus.FeatureXSample.transform(fe_, sa_, mf; lo, nr = pl, nc = ns, nn)

    write(ou, ns, sa_, ch_, mc, pl, fe_, nn, mf, ch)

    sa_, ch_, mc, pl, fe_, mf

end

end
