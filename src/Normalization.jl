module Normalization

using StatsBase: competerank, denserank, mean, quantile, std, tiedrank

using ..Omics

function normalize_with_0!(nu_)

    me = mean(nu_)

    st = std(nu_)

    map!(nu -> (nu - me) / st, nu_, nu_)

end

function normalize_with_01!(nu_)

    mi, ma = extrema(nu_)

    ra = ma - mi

    map!(nu -> (nu - mi) / ra, nu_, nu_)

end

function normalize_with_sum!(nu_)

    su = sum(nu_)

    map!(nu -> nu / su, nu_, nu_)

end

function normalize_with_logistic!(nu_)

    map!(Omics.Probability.get_logistic, nu_, nu_)

end

function normalize_with_1223!(nu_)

    copyto!(nu_, denserank(nu_))

end

function normalize_with_1224!(nu_)

    copyto!(nu_, competerank(nu_))

end

function normalize_with_125254!(nu_)

    copyto!(nu_, tiedrank(nu_))

end

function normalize_with_quantile!(nu_, fr_ = (0.0, 0.5, 1.0))

    qu_ = quantile(nu_, fr_)

    iq_ = 1:(lastindex(qu_) - 1)

    for iu in eachindex(nu_)

        for iq in iq_

            if qu_[iq] <= nu_[iu] <= qu_[iq + 1]

                nu_[iu] = iq

                break

            end

        end

    end

end

function shift!(nu_)

    mi = minimum(nu_)

    map!(nu -> nu - mi, nu_, nu_)

end

function shift_log2!(nu_)

    mi = minimum(nu_)

    map!(nu -> log2(nu - mi + 1), nu_, nu_)

end

function standardize_clamp!(nu_, st)

    if allequal(nu_)

        @warn "All $(nu_[1])."

        fill!(nu_, 0.0)

    else

        clamp!(normalize_with_0!(nu_), -st, st)

    end

end

function standardize_clamp!(::AbstractVector{<:Integer}, ::Any) end

function rank_01!(nu_)

    normalize_with_01!(normalize_with_125254!(nu_))

end

end
