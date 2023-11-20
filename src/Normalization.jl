module Normalization

using StatsBase: competerank, denserank, mean, quantile, std, tiedrank

using ..Nucleus

function normalize_with_0!(nu_)

    nu_ .= (nu_ .- mean(nu_)) ./ std(nu_)

    nothing

end

function normalize_with_01!(nu_)

    mi, ma = Nucleus.Collection.get_minimum_maximum(nu_)

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

function _update!(fu, nu_)

    for (id, nu) in enumerate(fu(nu_))

        nu_[id] = nu

    end

end

function normalize_with_1223!(nu_)

    _update!(denserank, nu_)

end

function normalize_with_1224!(nu_)

    _update!(competerank, nu_)

end

function normalize_with_125254!(nu_)

    _update!(tiedrank, nu_)

end

function normalize_with_quantile!(nu_, qu_ = (0, 0.5, 1))

    qu_ = quantile(nu_, qu_)

    n = lastindex(qu_) - 1

    for (id, nu) in enumerate(nu_)

        for idq in 1:n

            if qu_[idq] <= nu <= qu_[idq + 1]

                nu_[id] = idq

                break

            end

        end

    end

end

end
