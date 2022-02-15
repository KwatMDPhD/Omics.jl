function get_confidence_interval(co)

    cu = (1.0 - co) / 2.0

    get_z_score(cu), get_z_score(1.0 - cu)

end
