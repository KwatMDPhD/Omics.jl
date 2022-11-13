function _match_algorithm(al)

    if al == "ks"

        score_set, 1

    elseif al == "ksa"

        score_set, 2

    elseif al == "cidac"

        score_set_new, 2

    else

        error()

    end

end
