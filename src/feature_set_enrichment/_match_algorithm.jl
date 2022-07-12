function _match_algorithm(al)

    if al == "ks"

        fu = OnePiece.feature_set_enrichment.score_set

        st = 1

    elseif al == "ksa"

        fu = OnePiece.feature_set_enrichment.score_set

        st = 2

    elseif al == "cidac"

        fu = OnePiece.feature_set_enrichment.score_set_new

        st = 2

    end

    fu, st

end

function _match_algorithm(se_en::Dict, st)

    Dict(se => en[st] for (se, en) in se_en)

end

function _match_algorithm(se_en__::Vector, st)

    [Dict(se => en[st] for (se, en) in se_en) for se_en in se_en__]

end
