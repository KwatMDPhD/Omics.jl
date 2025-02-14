module Entropy

function ge(pr)

    iszero(pr) ? 0.0 : -pr * log2(pr)

end

function ge(fu, pr)

    sum(pr_ -> ge(sum(pr_)), fu(pr))

end

end
