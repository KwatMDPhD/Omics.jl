function _match_algorithm(al)

    if al == "KS"

        fu = score_set_ks

    elseif al == "KSA"

        fu = score_set_auc

    elseif al == "KL"

        score_set_kl

    elseif al == "SKL"

        score_set_skl

    elseif al == "AKL"

        score_set_akl

    else

        error()

    end

end
