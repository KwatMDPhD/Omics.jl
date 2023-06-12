module NumberArray

using StatsBase: competerank, denserank, mean, ordinalrank, std, tiedrank

using ..BioLab

function error_negative(ar)

    if any(<(0), ar)

        error("There is a negative.")

    end

end

function get_area(ar)

    sum(ar) / length(ar)

end

function get_extreme(ar)

    mi = minimum(ar)

    ma = maximum(ar)

    if mi == ma

        return (mi,)

    end

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

function range(ar::AbstractArray{Int}, ::Int)

    minimum(ar):maximum(ar)

end

function range(ar, n)

    mi = minimum(ar)

    ma = maximum(ar)

    mi:((ma - mi) / n):ma

end

function skip_nan_apply!!(fu!, ar)

    go_ = [!isnan(nu) for nu in ar]

    if any(go_)

        fu!(view(ar, go_))

    end

end

function skip_nan_apply!(fu, ar)

    go_ = [!isnan(nu) for nu in ar]

    if any(go_)

        ar[go_] = fu(ar[go_])

    end

end

function shift_minimum(ar, mi::Real)

    sh = mi - minimum(ar)

    [nu + sh for nu in ar]

end

function shift_minimum(ar, st)

    shift_minimum(ar, minimum(filter(>(parse(Float64, BioLab.String.split_get(st, '<', 1))), ar)))

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
