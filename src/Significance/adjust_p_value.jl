function adjust_p_value_with_bonferroni(pv_, n = length(pv_))

    clamp!(pv_ * n, 0.0, 1.0)

end

function adjust_p_value_with_benjamini_hochberg(pv_, n = length(pv_))

    so_ = sortperm(pv_)

    nf = convert(Float64, n)

    pvs_ = [pv_[so] * nf / convert(Float64, id) for (id, so) in enumerate(so_)]

    BioLab.VectorNumber.force_increasing_with_min!(pvs_)

    clamp!(pvs_[sortperm(so_)], 0.0, 1.0)

end
