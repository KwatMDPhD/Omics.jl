function _get_p_value(n, ra_)

    if n == 0

        n = 1

    end

    return n / length(ra_)

end

function get_p_value_for_less(nu, ra_)

    return _get_p_value(sum((ra <= nu for ra in ra_)), ra_)

end

function get_p_value_for_more(nu, ra_)

    return _get_p_value(sum((nu <= ra for ra in ra_)), ra_)

end
