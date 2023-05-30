module VectorNumber

using Distributions: Normal

using Random: seed!

using ..BioLab

function get_area(nu_)

    sum(nu_) / length(nu_)

end

function get_extreme(nu_)

    mi = minimum(nu_)

    ma = maximum(nu_)

    mia = abs(mi)

    maa = abs(ma)

    if isapprox(mia, maa)

        (mi, ma)

    elseif maa < mia

        (mi,)

    elseif mia < maa

        (ma,)

    else

        error()

    end

end

function range(nu_, n)

    minimum(nu_):n:maximum(nu_)

end

function range(nu_::AbstractArray{Int}, n)

    minimum(nu_):maximum(nu_)

end

function shift_minimum(nu_, mi::Real)

    sh = mi - minimum(nu_)

    [nu + sh for nu in nu_]

end

function shift_minimum(nu_, st)

    fl = parse(eltype(nu_), BioLab.String.split_get(st, '<', 1))

    shift_minimum(nu_, minimum(filter(>(fl), nu_)))

end

function force_increasing_with_min!(nu_)

    accumulate!(min, nu_, reverse!(nu_))

    reverse!(nu_)

    return nothing

end

function force_increasing_with_max!(nu_)

    accumulate!(max, nu_, nu_)

    return nothing

end

function skip_nanapply!!(fu!, nu_)

    go_ = [!isnan(nu) for nu in nu_]

    if any(go_)

        fu!(view(nu_, go_))

    end

    return nothing

end

function skip_nanapply!(fu, nu_)

    go_ = [!isnan(nu) for nu in nu_]

    if any(go_)

        nu_[go_] = fu(nu_[go_])

    end

    return nothing

end

# TODO: Multiple-dispatch.
function simulate(n; ra = BioLab.RA, di = "Normal", ho = "", ev = true)

    if di == "Normal"

        di = Normal()

    else

        erorr()

    end

    seed!(ra)

    ra_ = rand(di, n)

    po_ = shift_minimum(ra_, 0.0)

    sort!(po_)

    ne_ = reverse(-po_)

    if isempty(ho)

        nem_ = ne_

    elseif ho == "deep"

        nem_ = ne_ * 2.0

    elseif ho == "long"

        nem_ = Vector{Float64}(undef, n * 2 - 1)

        for (id, ne) in enumerate(ne_)

            id2 = id * 2

            nem_[id2 - 1] = ne

            if id < n

                nem_[id2] = (ne + ne_[id + 1]) / 2.0

            end

        end

    else

        error()

    end

    if !ev

        nem_ = nem_[1:(end - 1)]

    end

    # TODO: Preallocate.
    return vcat(nem_, po_)

end

end
