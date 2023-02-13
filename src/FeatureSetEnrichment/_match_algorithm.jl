# TODO: multiple-dispatch.
function _match_algorithm(al)

    if al == "KS"

        score_set_ks

    elseif al == "KSa"

        score_set_ksa

    elseif al == "KLi"

        score_set_kli

    elseif al == "KLiop"

        score_set_kliop

    elseif al == "KLiom"

        score_set_kliom

    else

        error()

    end

end
