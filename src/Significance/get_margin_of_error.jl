function get_margin_of_error(nu_, co = 0.95)

    return BioLab.Statistics.get_confidence_interval(co)[2] * std(nu_) / sqrt(length(nu_))

end
