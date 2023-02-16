# TODO: Multiple-dispatch.
function _match_algorithm(al)

    if al == "KS"

        return score_set_ks

    elseif al == "KSa"

        return score_set_ksa

    elseif al == "KLi"

        return score_set_kli

    elseif al == "KLiop"

        return score_set_kliop

    elseif al == "KLiom"

        return score_set_kliom

    else

        error()

    end

end
