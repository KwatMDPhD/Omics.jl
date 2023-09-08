module Normalization

using StatsBase: competerank, denserank, mean, std, tiedrank

function normalize_with_sum!(ar)

    ar ./= sum(ar)

end

function normalize_with_01!(ar)

    mi = minimum(ar)

    ar .= (ar .- mi) ./ (maximum(ar) - mi)

end

function normalize_with_0!(ar)

    ar .= (ar .- mean(ar)) ./ std(ar)

end

function _normalize_with_rank!(fu, ar)

    for (id, nu) in enumerate(fu(ar))

        ar[id] = nu

    end

end

function normalize_with_1223!(ar)

    _normalize_with_rank!(denserank, ar)

end

function normalize_with_1224!(ar)

    _normalize_with_rank!(competerank, ar)

end

function normalize_with_125254!(ar)

    _normalize_with_rank!(tiedrank, ar)

end

end
