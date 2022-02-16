function update(me, st)

    fa = 0.2

    lo = abs(me) * fa

    if me == 0.0

        st = fa

    elseif st < lo

        st = lo

    end

    me, st

end

function get_signal_to_noise_ratio(te1, te2)

    co = true

    me1, st1 = update(mean(te1), std(te1, corrected = co))

    me2, st2 = update(mean(te2), std(te2, corrected = co))

    (me1 - me2) / (st1 + st2)

end
