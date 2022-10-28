function _match_algorithm(al)

    if al == "ks"

        fu = score_set

        id = 1

    elseif al == "ksa"

        fu = score_set

        id = 2

    elseif al == "cidac"

        fu = score_set_new

        id = 2

    else

        error("Algorithm is not `cidac`, `ks` or `ksa`.")

    end

    fu, id

end

function _match_algorithm(se_en, id)

    Dict(se => en[id] for (se, en) in se_en)

end

function _match_algorithm(se_en_::AbstractVector, id)

    [_match_algorithm(se_en, id) for se_en in se_en_]

end
