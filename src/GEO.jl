module GEO

using DataFrames: DataFrame, outerjoin, rename!, select!

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

function read(gs; di = BioLab.TE, pr = true)

    fi = "$(gs)_family.soft.gz"

    gz = joinpath(di, fi)

    if ispath(gz)

        if pr

            println("🤞 Using $gz")

        end

    else

        download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs[1:end-3])nnn/$gs/soft/$fi", gz)

    end

    ty = nothing

    bl = nothing

    ty_bl = Dict{String, OrderedDict{String, OrderedDict{String, Any}}}()

    eq = " = "

    ket = "an_"

    for li in split(Base.read(open(gz, "r"), String), '\n')[1:(end - 1)]

        if startswith(li, '^')

            if pr

                println("📍 $li")

            end

            ty, bl = split(li[2:end], eq; limit = 2)

            get!(ty_bl, ty, OrderedDict{String, OrderedDict{String, Any}}())[bl] =
                OrderedDict{String, Any}()

            continue

        end

        ke_va = ty_bl[ty][bl]

        # TODO: Use `_data_row_count`.
        if startswith(li, "!$(lowercase(ty))_table_")

            if endswith(li, "begin")

                ke_va[ket] = Vector{Vector{String}}()

            elseif endswith(li, "end")

                fe_x_in_x_an = BioLab.DataFrame.make(pop!(ke_va, ket))

                if size(fe_x_in_x_an, 1) !=
                   parse(Int, pop!(ke_va, "!$(titlecase(ty))_data_row_count"))

                    error()

                end

                ke_va["fe_x_in_x_an"] = fe_x_in_x_an

            else

                error()

            end

            continue

        end

        if haskey(ke_va, ket)

            push!(ke_va[ket], split(li, '\t'))

        else

            ke, va = split(li, eq; limit = 2)

            BioLab.Dict.set_with_suffix!(ke_va, ke, va)

        end

    end

    return ty_bl

end

function _name(pl, fe_x_in_x_an; pr = true)

    pl = parse(Int, pl[4:end])

    if pr

        println("🚉 $pl")

    end

    ke = "ID"

    if pl in (96, 97, 570, 13667)

        va = "Gene Symbol"

        fu = na -> BioLab.String.split_and_get(na, " /// ", 1)

    elseif pl == 13534

        va = "UCSC_RefGene_Name"

        fu = na -> BioLab.String.split_and_get(na, ';', 1)

    elseif pl in (5175, 6244, 11532, 17586)

        va = "gene_assignment"

        fu = na -> BioLab.String.split_and_get(na, " // ", 2)

    elseif pl in (2004, 2005, 3718, 3720)

        va = "Associated Gene"

        fu = na -> BioLab.String.split_and_get(na, " // ", 1)

    elseif pl in (6098, 6884, 6947, 10558, 14951)

        va = "Symbol"

        fu = na -> na

    elseif pl == 16686

        va = "GB_ACC"

        fu = na -> na

    elseif pl == 10332

        va = "GENE_SYMBOL"

        fu = na -> na

    else

        error(pl)

    end

    if pr

        println("🧭 Mapping platform features using the platform table ($ke ➡️ $va)")

        println(first(fe_x_in_x_an, 2))

    end

    fe_na = Dict{String, String}()

    for (fe, na) in zip(fe_x_in_x_an[!, ke], fe_x_in_x_an[!, va])

        if na isa AbstractString && !isempty(na) && na != "---"

            BioLab.Dict.set_with_last!(fe_na, fe, fu(na))

        end

    end

    if pr

        BioLab.Dict.print(fe_na; n = 0)

    end

    return fe_na

end

function tabulate(ty_bl; sa = "!Sample_title", pr = true)

    sa_ke_va = OrderedDict(ke_va[sa] => ke_va for ke_va in values(ty_bl["SAMPLE"]))

    ch = "Characteristic"

    de = ": "

    co_st____ = Vector{Dict{String, Vector{String}}}()

    pl_co_nu____ = Dict{String, Vector{Dict{String, Vector{String}}}}()

    for (sa, ke_va) in sa_ke_va

        ch_ = [va for (ke, va) in ke_va if startswith(ke, "!Sample_characteristics")]

        if all(contains(ch, de) for ch in ch_)

            sp_ = [split(ch, de; limit = 2) for ch in ch_]

            push!(co_st____, Dict(ch => [sp[1] for sp in sp_], sa => [sp[2] for sp in sp_]))

        else

            println("⚠️ A $sa characteristic lacks \"$de\":\n  $(join(ch_, "\n  "))")

        end

        pl = ke_va["!Sample_platform_id"]

        co_nu____ = get!(pl_co_nu____, pl, Vector{Dict{String, Vector{String}}}())

        if haskey(ke_va, "fe_x_in_x_an")

            fe_x_in_x_an = ke_va["fe_x_in_x_an"]

            push!(co_nu____, Dict(pl => fe_x_in_x_an[!, 1], sa => fe_x_in_x_an[!, "VALUE"]))

        else

            println("⚠️ $sa table is empty.")

        end

    end

    ch_x_sa_x_an = _outerjoin(co_st____, ch)

    if pr

        BioLab.DataFrame.print_unique(ch_x_sa_x_an; di = 1)

    end

    fe_x_sa_x_nu_____ = Vector{DataFrame}(undef, length(pl_co_nu____))

    for (id, (pl, co_nu____)) in enumerate(pl_co_nu____)

        fe_x_sa_x_nu = _outerjoin(co_nu____, pl)

        # TODO: Type.

        pl_ke_va = ty_bl["PLATFORM"]

        if haskey(pl_ke_va[pl], "fe_x_in_x_an")

            fe_na = _name(pl, pl_ke_va[pl]["fe_x_in_x_an"]; pr = pr)

            fe_x_sa_x_nu[!, pl] = [get(fe_na, fe, "_$fe") for fe in fe_x_sa_x_nu[!, pl]]

            n_fe = size(fe_x_sa_x_nu, 1)

            if pr

                println(
                    "📛 Renamed $(n_fe - count(startswith('_'), fe_x_sa_x_nu[!, 1])) / $n_fe $pl $(BioLab.String.count_noun(n_fe,"feature")).",
                )

            end

        else

            println("⚠️ $pl table is empty.")

        end

        fe_x_sa_x_nu_____[id] = fe_x_sa_x_nu

    end

    # TODO: Do not splat.
    return ch_x_sa_x_an, fe_x_sa_x_nu_____...

end

function _outerjoin(co_va____, on)

    if isempty(co_va____)

        return DataFrame()

    else

        return select!(outerjoin(DataFrame.(co_va____)...; on = on), on, :)

    end

end

end
