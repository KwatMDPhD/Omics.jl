function _update(me, st)

    fa = 0.2

    lo = abs(me) * fa

    if me == 0.0

        st = fa

    elseif st < lo

        st = lo

    end

    me, st

end

function get_signal_to_noise_ratio(ve1, ve2)

    co = true

    me1, st1 = _update(mean(ve1), std(ve1, corrected = co))

    me2, st2 = _update(mean(ve2), std(ve2, corrected = co))

    (me1 - me2) / (st1 + st2)

end
