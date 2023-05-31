module Normalization

using StatsBase: competerank, denserank, mean, ordinalrank, std, tiedrank

function normalize_with_01!(te)

    mi = minimum(te)

    ra = maximum(te) - mi

    if iszero(ra)

        error("Can not 0-1-normalize numbers that are all equal.")

    end

    for (id, nu) in enumerate(te)

        te[id] = (nu - mi) / ra

    end

end

function normalize_with_0!(te)

    me = mean(te)

    st = std(te)

    if iszero(st)

        error("Can not -0-normalize numbers with 0 standard deviation.")

    end

    for (id, nu) in enumerate(te)

        te[id] = (nu - me) / st

    end

end

function normalize_with_sum!(te)

    if any(nu < 0.0 for nu in te)

        error("Can not sum-normalize numbers with any negative.")

    end

    su = sum(te)

    for (id, nu) in enumerate(te)

        te[id] = nu / su

    end

end

function _normalize_with_rank!(te, fu)

    if allequal(te)

        error("Can not rank-normalize numbers that are all equal.")

    end

    for (id, nu) in enumerate(fu(te))

        te[id] = nu

    end

end

function normalize_with_1234!(te)

    _normalize_with_rank!(te, ordinalrank)

end

function normalize_with_1223!(te)

    _normalize_with_rank!(te, denserank)

end

function normalize_with_1224!(te)

    _normalize_with_rank!(te, competerank)

end

function normalize_with_125254!(te)

    _normalize_with_rank!(te, tiedrank)

end

end
