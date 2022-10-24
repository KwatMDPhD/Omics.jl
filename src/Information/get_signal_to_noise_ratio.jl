function _get_standard_deviation(ve, me)

    fr = 0.2

    if me == 0.0

        fr

    else

        max(abs(me) * fr, std(ve, corrected = true))

    end

end

function get_signal_to_noise_ratio(ve1, ve2)

    me1 = mean(ve1)

    me2 = mean(ve2)

    (me2 - me1) / (_get_standard_deviation(ve1, me1) + _get_standard_deviation(ve2, me2))

end
