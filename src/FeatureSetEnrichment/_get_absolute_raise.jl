function _get_absolute_raise(sc_, id, ex)

    abe = sc_[id]

    if abe < 0.0

        abe = -abe

    end

    if ex != 1.0

        abe ^= ex

    end

    abe

end
