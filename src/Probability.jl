module Probability

function get_odd(pr)

    pr / (1 - pr)

end

function ge(od)

    od / (1 + od)

end

function get_logistic(nu)

    ge(exp(nu))

end

end
