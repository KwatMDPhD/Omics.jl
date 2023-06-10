module NumberArray

using StatsBase: competerank, denserank, mean, ordinalrank, std, tiedrank

using ..BioLab

function error_negative(ar)

    if any(nu < 0 for nu in ar)

        error("There is a negative.")

    end

end

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

function normalize_with_01!(ar)

    BioLab.Collection.error_no_change(ar)

    mi = minimum(ar)

    ra = maximum(ar) - mi

    for (id, nu) in enumerate(ar)

        ar[id] = (nu - mi) / ra

    end

end

function normalize_with_0!(ar)

    BioLab.Collection.error_no_change(ar)

    me = mean(ar)

    st = std(ar)

    for (id, nu) in enumerate(ar)

        ar[id] = (nu - me) / st

    end

end

function normalize_with_sum!(ar)

    error_negative(ar)

    su = sum(ar)

    for (id, nu) in enumerate(ar)

        ar[id] = nu / su

    end

end

function _normalize_with_rank!(ar, fu)

    BioLab.Collection.error_no_change(ar)

    for (id, nu) in enumerate(fu(ar))

        ar[id] = nu

    end

end

function normalize_with_1234!(ar)

    _normalize_with_rank!(ar, ordinalrank)

end

function normalize_with_1223!(ar)

    _normalize_with_rank!(ar, denserank)

end

function normalize_with_1224!(ar)

    _normalize_with_rank!(ar, competerank)

end

function normalize_with_125254!(ar)

    _normalize_with_rank!(ar, tiedrank)

end

end
