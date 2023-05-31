module Normalization

using StatsBase: competerank, denserank, mean, ordinalrank, std, tiedrank

function normalize_with_01!(te)

    mi = minimum(te)

    ra = maximum(te) - mi

    if ra == 0

        error()

    end

    for (id, nu) in enumerate(te)

        te[id] = (nu - mi) / ra

    end

    return nothing

end

function normalize_with_0!(te)

    me = mean(te)

    st = std(te)

    if st == 0

        error()

    end

    for (id, nu) in enumerate(te)

        te[id] = (nu - me) / st

    end

    return nothing

end

function normalize_with_sum!(te)

    if any(nu < 0.0 for nu in te)

        error()

    end

    su = sum(te)

    for (id, nu) in enumerate(te)

        te[id] = nu / su

    end

    return nothing

end

function _!(nu1_, nu2_)

    for (id, nu2) in enumerate(nu2_)

        nu1_[id] = nu2

    end

    return nothing

end

function normalize_with_1234!(te)

    return _!(te, ordinalrank(te))

end

function normalize_with_1223!(te)

    return _!(te, denserank(te))

end

function normalize_with_1224!(te)

    return _!(te, competerank(te))

end

function normalize_with_125254!(te)

    return _!(te, tiedrank(te))

end

end
