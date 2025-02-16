module Entropy

function ge(pr)

    iszero(pr) ? 0.0 : -pr * log2(pr)

end

function ge(ea, pr)

    sum(pr_ -> ge(sum(pr_)), ea(pr))

end

end
