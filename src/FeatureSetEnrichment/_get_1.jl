function _get_1(sc_, id, ex)

    ab = sc_[id]

    if ab < 0.0

        ab = -ab

    end

    if ex != 1.0

        ab ^= ex

    end

    ab

end
