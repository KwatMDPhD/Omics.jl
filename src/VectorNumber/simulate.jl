function simulate(n_po; ho = "", ra = OnePiece.constant.RANDOM_SEED)

    di = Normal()

    Random.seed!(ra)

    po_ = rand(di, n_po)

    po_ = shift_minimum(po_, 0)

    sort!(po_)

    ne_ = reverse(-po_)

    if ho == "deep"

        ne_ *= 2

    elseif ho == "long"

        ne_ = sort(vcat(ne_, [mean(ne_[(id - 1):id]) for id in 2:length(ne_)]))

    end

    vcat(ne_, po_)

end
