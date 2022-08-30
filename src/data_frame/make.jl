function make(ro_)

    na_ = ro_[1]

    DataFrame([ro_[n_ro][n_co] for n_ro in 2:length(ro_), n_co in 1:length(na_)], na_)

end
