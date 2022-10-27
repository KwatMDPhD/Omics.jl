function _cumulate(ve)

    ep = eps()

    cur_ = [cu + ep for cu in cumsum(ve)]

    cul_ = [cu + ep for cu in OnePiece.VectorNumber.reverse_cumulate(ve)]

    su = sum(ve)

    cur_ / su, cul_ / su

end
