module Difference

using StatsBase: mean, std

function get_mean_difference(n1_, n2_)

    mean(n2_) - mean(n1_)

end

function get_standard_deviation(nu_, me)

    max(0.2 * abs(me), std(nu_; corrected = true))

end

function get_signal_to_noise_ratio(n1_, n2_)

    m1 = mean(n1_)

    m2 = mean(n2_)

    (m2 - m1) / (get_standard_deviation(n1_, m1) + get_standard_deviation(n2_, m2))

end

function get_log_ratio(n1_, n2_)

    m1 = mean(n1_)

    m2 = mean(n2_)

    iszero(m1) || iszero(m2) ? NaN : log2(m2 / m1)

end

end
