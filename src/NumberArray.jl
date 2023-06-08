module NumberArray

using StatsBase: competerank, denserank, mean, ordinalrank, std, tiedrank

using ..BioLab

function error_negative(ar)

    if any(nu < 0 for nu in ar)

        error("There is a negative.")

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
