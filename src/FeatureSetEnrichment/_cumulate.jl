function _cumulate(nu_)

    ep = eps()

    cur_ = [cu + ep for cu in cumsum(nu_)]

    cul_ = [cu + ep for cu in BioinformaticsCore.VectorNumber.reverse_cumulate(nu_)]

    su = sum(nu_)

    cur_ / su, cul_ / su

end
