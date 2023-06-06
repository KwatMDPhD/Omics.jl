module VectorNumber

using Distributions: Normal

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

    else#if mia < maa

        (ma,)

    end

end

# TODO: Test.

function range(nu_, n)

    mi = minimum(nu_)

    ma = maximum(nu_)

    mi:((ma - mi) / n):ma

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

    reverse!(accumulate!(min, nu_, reverse!(nu_)))

end

function force_increasing_with_max!(nu_)

    accumulate!(max, nu_, nu_)

end

function skip_nan_apply!!(fu!, nu_)

    go_ = [!isnan(nu) for nu in nu_]

    if any(go_)

        fu!(view(nu_, go_))

    end

end

function skip_nan_apply!(fu, nu_)

    go_ = [!isnan(nu) for nu in nu_]

    if any(go_)

        nu_[go_] = fu(nu_[go_])

    end

end

struct Original end

struct Deep end

struct Wide end

function simulate(n, ty; ze = true)

    ra_ = rand(Normal(), n)

    po_ = shift_minimum(ra_, 0)

    sort!(po_)

    ne_ = reverse(-po_)

    nem_ = simulate(ne_, ty)

    if !ze

        nem_ = nem_[1:(end - 1)]

    end

    vcat(nem_, po_)

end

function simulate(ne_, ::Type{Original})

    ne_

end

function simulate(ne_, ::Type{Deep})

    ne_ * 2

end

function simulate(ne_, ::Type{Wide})

    n = length(ne_)

    nem_ = Vector{Float64}(undef, n * 2 - 1)

    for (id, ne) in enumerate(ne_)

        id2 = id * 2

        nem_[id2 - 1] = ne

        if id < n

            nem_[id2] = (ne + ne_[id + 1]) / 2

        end

    end

    nem_

end

end
