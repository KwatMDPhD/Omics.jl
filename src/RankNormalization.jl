module RankNormalization

using StatsBase: competerank, denserank, quantile, tiedrank

function do_1223!(nu_)

    copyto!(nu_, denserank(nu_))

end

function do_1224!(nu_)

    copyto!(nu_, competerank(nu_))

end

function do_125254!(fl_)

    copyto!(fl_, tiedrank(fl_))

end

function do_quantile!(nu_, qu_ = (0.5, 1.0))

    ma_ = quantile(nu_, qu_)

    map!(nu -> findfirst(>=(nu), ma_), nu_, nu_)

end

end
