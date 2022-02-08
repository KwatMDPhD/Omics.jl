function get_margin_of_error(ve; co = 0.95)

    return get_confidence_interval(co)[2] * std(ve) /
           sqrt(length(ve))

end
