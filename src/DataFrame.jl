module DataFrame

using DataFrames: DataFrame as _DataFrame, insertcols!

using OrderedCollections: OrderedDict

using StatsBase: countmap, mean

using ..BioLab

function make(an__)

    BioLab.Array.error_size(an__)

    co_ = an__[1]

    return _DataFrame([[an_[id] for an_ in an__[2:end]] for id in eachindex(co_)], co_)

end

function make(ro, ro_, co_, _x_co_x_an)

    return insertcols!(_DataFrame(_x_co_x_an, co_), 1, ro => ro_)

end

function separate(ro_x_co_x_an)

    co_ = names(ro_x_co_x_an)

    id_ = 2:length(co_)

    return co_[1],
    ro_x_co_x_an[:, 1]::Vector{<:AbstractString},
    co_[id_],
    Matrix(ro_x_co_x_an[!, id_])

end

function _print_unique(na_, an__)

    for (na, an_) in zip(na_, an__)

        println("🔦 $na")

        BioLab.Dict.print(sort(countmap(an_); byvalue = true))

    end

    return nothing

end

function print_column(ro_x_co_x_an)

    return _print_unique(names(ro_x_co_x_an), eachcol(ro_x_co_x_an))

end

function print_row(ro_x_co_x_an)

    return _print_unique(ro_x_co_x_an[!, 1], eachrow(ro_x_co_x_an))

end

function collapse(ro_x_co_x_nu; fu = mean, pr = true)

    BioLab.check_print(pr, "📐 Before $(size(ro_x_co_x_nu))")

    ro_id_ = OrderedDict{String, Vector{Int}}()

    ro, ro_, co_, ma::Matrix{Float64} = BioLab.DataFrame.separate(ro_x_co_x_nu)

    for (id, ro) in enumerate(ro_)

        push!(get!(ro_id_, ro, Int[]), id)

    end

    n = length(ro_id_)

    if length(ro_) == n

        BioLab.check_print(pr, "🤭 There are no rows to collapse.")

        return ro_x_co_x_nu

    end

    roc_ = Vector{String}(undef, n)

    mac = Matrix{Float64}(undef, (n, length(co_)))

    for (id, (ro, id_)) in enumerate(ro_id_)

        roc_[id] = ro

        if length(id_) == 1

            nu_ = ma[id_[1], :]

        else

            nu_ = [fu(nu_) for nu_ in eachcol(ma[id_, :])]

        end

        mac[id, :] = nu_

    end

    roc_x_co_x_nuc = BioLab.DataFrame.make(ro, roc_, co_, mac)

    BioLab.check_print(pr, "📐 After $(size(roc_x_co_x_nuc)).")

    return roc_x_co_x_nuc

end

function map_to(ro_x_co_x_st, fu, fr_, to; de = "", pr = false)

    fr_to = Dict{String, String}()

    for (fr_, to) in zip(eachrow(ro_x_co_x_st[!, fr_]), ro_x_co_x_st[!, to])

        if ismissing(to)

            continue

        end

        fu(fr_to, to, to; pr)

        for fr in fr_

            if ismissing(fr)

                continue

            end

            if isempty(de)

                fr_ = [fr]

            else

                fr_ = split(fr, de)

            end

            for fr in fr_

                fu(fr_to, fr, to; pr)

            end

        end

    end

    return fr_to

end

end
