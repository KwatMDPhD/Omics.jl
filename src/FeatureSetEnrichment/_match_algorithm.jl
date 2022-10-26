function _match_algorithm(al)

    if al == "ks"

        fu = score_set

        st = 1

    elseif al == "ksa"

        fu = score_set

        st = 2

    elseif al == "cidac"

        fu = score_set_new

        st = 2

    else

        error("Algorithm is not `cidac`, `ks` or `ksa`.")

    end

    fu, st

end

function _match_algorithm(se_en, st)

    Dict(se => en[st] for (se, en) in se_en)

end

function _match_algorithm(se_en_::AbstractVector, st)

    [_match_algorithm(se_en, st) for se_en in se_en_]

end
