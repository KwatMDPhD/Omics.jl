module Entropy

function ge(pr::Real)

    -pr * log2(pr)

end

function ge(jo)

    sum(pr -> iszero(pr) ? 0.0 : ge(pr), jo)

end

function ge(ea, jo)

    sum(pr_ -> ge(sum(pr_)), ea(jo))

end

end
