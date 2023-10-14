module Normalization

using StatsBase: competerank, denserank, mean, std, tiedrank

using ..BioLab

function normalize_with_0!(nu_)

    nu_ .= (nu_ .- mean(nu_)) ./ std(nu_)

    nothing

end

function normalize_with_01!(nu_)

    mi, ma = BioLab.Collection.get_minimum_maximum(nu_)

    ra = ma - mi

    nu_ .= (nu_ .- mi) ./ ra

    nothing

end

function normalize_with_sum!(nu_)

    nu_ ./= sum(nu_)

    nothing

end

function normalize_with_logistic!(nu_)

    for (id, nu) in enumerate(nu_)

        ex = exp(nu)

        nu_[id] = ex / (1 + ex)

    end

end

function _no!(fu, nu_)

    for (id, nu) in enumerate(fu(nu_))

        nu_[id] = nu

    end

end

function normalize_with_1223!(nu_)

    _no!(denserank, nu_)

end

function normalize_with_1224!(nu_)

    _no!(competerank, nu_)

end

function normalize_with_125254!(nu_)

    _no!(tiedrank, nu_)

end

end
