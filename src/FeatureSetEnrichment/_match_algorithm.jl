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

function _match_algorithm(se_en, id)

    Dict(se => en[id] for (se, en) in se_en)

end

function _match_algorithm(se_en_::AbstractVector, id)

    [_match_algorithm(se_en, id) for se_en in se_en_]

end
