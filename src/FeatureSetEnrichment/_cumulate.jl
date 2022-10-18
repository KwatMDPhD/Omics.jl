function _cumulate(ve)

    ep = eps()

    cur_ = cumsum(ve) .+ ep

    cul_ = OnePiece.vector_number.cumulate_sum_reverse(ve) .+ ep

    su = sum(ve)

    cur_ / su, cul_ / su

end
