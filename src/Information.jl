module Information

using StatsBase: mean, std

using ..BioLab

function get_entropy(nu_)

    return 0.0

end

function _get_standard_deviation(nu_, me)

    fr = 0.2

    if me == 0.0

        return fr

    else

        if me < 0.0

            me = -me

        end

        return max(me * fr, std(nu_; corrected = true))

    end

end

function get_signal_to_noise_ratio(nu1_, nu2_)

    me1 = mean(nu1_)

    me2 = mean(nu2_)

    return (me1 - me2) / (_get_standard_deviation(nu1_, me1) + _get_standard_deviation(nu2_, me2))

end

function get_kullback_leibler_divergence(nu1_, nu2_)

    return [nu1 * log(nu1 / nu2) for (nu1, nu2) in zip(nu1_, nu2_)]

end

function get_thermodynamic_breadth(nu1_, nu2_)

    return [
        nu1 + nu2 for (nu1, nu2) in zip(
            get_kullback_leibler_divergence(nu1_, nu2_),
            get_kullback_leibler_divergence(nu2_, nu1_),
        )
    ]

end

function get_thermodynamic_depth(nu1_, nu2_)

    return [
        nu1 - nu2 for (nu1, nu2) in zip(
            get_kullback_leibler_divergence(nu1_, nu2_),
            get_kullback_leibler_divergence(nu2_, nu1_),
        )
    ]

end

function get_symmetric_kullback_leibler_divergence(nu1_, nu2_, nu_; we1 = 0.5, we2 = 0.5)

    return [
        nu1 * we1 + nu2 * we2 for (nu1, nu2) in
        zip(get_kullback_leibler_divergence(nu1_, nu_), get_kullback_leibler_divergence(nu2_, nu_))
    ]

end

function get_antisymmetric_kullback_leibler_divergence(nu1_, nu2_, nu_; we1 = 0.5, we2 = 0.5)

    return [
        nu1 * we1 - nu2 * we2 for (nu1, nu2) in
        zip(get_kullback_leibler_divergence(nu1_, nu_), get_kullback_leibler_divergence(nu2_, nu_))
    ]

end

function get_mutual_information(nu1_, nu2_)

    return 0.0

end

function get_information_coefficient(nu1_, nu2_)

    return get_mutual_information(nu1_, nu2_)

end

end
