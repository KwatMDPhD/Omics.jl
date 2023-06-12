module GEO

using DataFrames: DataFrame

using GZip: open

using OrderedCollections: OrderedDict

using ..BioLab

function _readline(st)

    readline(st; keep = false)

end

function read(gs; di = BioLab.TE)

    fi = "$(gs)_family.soft.gz"

    gz = joinpath(di, fi)

    if !ispath(gz)

        @info "Downloading $gz"

        download("ftp://ftp.ncbi.nlm.nih.gov/geo/series/$(gs[1:end-3])nnn/$gs/soft/$fi", gz)

    end

    ty_bl_ke_va = Dict(
        ty => OrderedDict{String, OrderedDict{String, String}}() for
        ty in ("DATABASE", "SERIES", "PLATFORM", "SAMPLE")
    )

    ty = ""

    bl = ""

    eq = " = "

    st = open(gz)

    while !eof(st)

        li = _readline(st)

        if startswith(li, '^')

            ty, bl = split(li[2:end], eq; limit = 2)

            ty_bl_ke_va[ty][bl] = OrderedDict{String, String}()

            continue

        end

        ta = "!$(lowercase(ty))_table_"

        if startswith(li, "$(ta)begin")

            ty_bl_ke_va[ty][bl]["table"] = join(
                (
                    _readline(st) for _ in
                    1:(1 + parse(Int, ty_bl_ke_va[ty][bl]["!$(titlecase(ty))_data_row_count"]))
                ),
                '\n',
            )

            if _readline(st) != "$(ta)end"

                error("$ta did not end.")

            end

            continue

        end

        ke, va = split(li, eq; limit = 2)

        BioLab.Dict.set_with_suffix!(ty_bl_ke_va[ty][bl], ke, va)

    end

    close(st)

    ty_bl_ke_va

end

function _name(pl, feature_x_information_x_anything)

    pli = parse(Int, pl[4:end])

    ke = "ID"

    if pli in (96, 97, 570, 13667)

        va = "Gene Symbol"

        fu = na -> BioLab.String.split_get(na, " /// ", 1)

    elseif pli == 13534

        va = "UCSC_RefGene_Name"

        fu = na -> BioLab.String.split_get(na, ';', 1)

    elseif pli in (5175, 6244, 11532, 17586)

        va = "gene_assignment"

        fu = na -> BioLab.String.split_get(na, " // ", 2)

    elseif pli in (2004, 2005, 3718, 3720)

        va = "Associated Gene"

        fu = na -> BioLab.String.split_get(na, " // ", 1)

    elseif pli in (6098, 6884, 6947, 10558, 14951)

        va = "Symbol"

        fu = na -> na

    elseif pli == 16686

        va = "GB_ACC"

        fu = na -> na

    elseif pli == 10332

        va = "GENE_SYMBOL"

        fu = na -> na

    elseif pli in (7566, 7567)

        error("$pli is a bad platform. Avoid it.")

    else

        error("$pli is a new platform. Implement it.")

    end

    fe_na = Dict{String, String}()

    for (fe, na) in
        zip(feature_x_information_x_anything[!, ke], feature_x_information_x_anything[!, va])

        if na isa AbstractString && !isempty(na) && na != "---"

            BioLab.Dict.set_with_last!(fe_na, fe, fu(na))

        end

    end

    fe_na

end

function tabulate(ty_bl_ke_va; sa = "!Sample_title", ig_ = ())

    sa_ke_va = OrderedDict(ke_va[sa] => ke_va for ke_va in values(ty_bl_ke_va["SAMPLE"]))

    sa_ = collect(keys(sa_ke_va))

    n_sa = length(sa_)

    de = ": "

    ch_st__ = fill(Dict{String, String}(), n_sa)

    pl_fe_fl__ = Dict{String, Vector{Dict{String, Float64}}}()

    for (id, (sa, ke_va)) in enumerate(sa_ke_va)

        ch_ = [
            va for (ke, va) in ke_va if startswith(ke, "!Sample_characteristics") &&
            (isempty(ig_) || !any(contains(va, ig) for ig in ig_))
        ]

        if all(contains(ch, de) for ch in ch_)

            merge!(ch_st__[id], Dict(split(ch, de; limit = 2) for ch in ch_))

        else

            @warn "A $sa characteristic lacks $de." ch_

        end

        if haskey(ke_va, "table")

            feature_x_information_x_anything = BioLab.DataFrame.make(ke_va["table"])

            merge!(
                get!(
                    pl_fe_fl__,
                    ke_va["!Sample_platform_id"],
                    fill(Dict{String, Float64}(), n_sa),
                )[id],
                Dict(
                    zip(
                        feature_x_information_x_anything[!, 1],
                        map(
                            st -> parse(Float64, st),
                            feature_x_information_x_anything[!, "VALUE"],
                        ),
                    ),
                ),
            )

        else

            @error "$sa table is empty."

        end

    end

    feature_x_sample_x_float_____ = Vector{DataFrame}(undef, length(pl_fe_fl__))

    for (id, (pl, fe_fl__)) in enumerate(pl_fe_fl__)

        feature_x_sample_x_float = BioLab.DataFrame.make(pl, sa_, fe_fl__)

        ke_va = ty_bl_ke_va["PLATFORM"][pl]

        if haskey(ke_va, "table")

            fe_na = _name(pl, BioLab.DataFrame.make(ke_va["table"]))

            feature_x_sample_x_float[!, 1] =
                [get(fe_na, fe, "_$fe") for fe in feature_x_sample_x_float[!, 1]]

        else

            @error "$pl table is empty."

        end

        feature_x_sample_x_float_____[id] = feature_x_sample_x_float

    end

    BioLab.DataFrame.make("Characteristic", sa_, ch_st__), feature_x_sample_x_float_____...

end

end
