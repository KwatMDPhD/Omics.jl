function _get_standard_deviation(nu_, me)

    fr = 0.2

    if me == 0.0

        fr

    else

        if me < 0.0

            me = -me

        end

        max(me * fr, std(nu_; corrected = true))

    end

end

function get_signal_to_noise_ratio(nu1_, nu2_)

    me1 = mean(nu1_)

    me2 = mean(nu2_)

    (me1 - me2) / (_get_standard_deviation(nu1_, me1) + _get_standard_deviation(nu2_, me2))

end
