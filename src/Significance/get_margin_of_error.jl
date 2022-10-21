function get_margin_of_error(te, co = 0.95)

    OnePiece.Statistics.get_confidence_interval(co)[2] * std(te) / sqrt(length(te))

end
