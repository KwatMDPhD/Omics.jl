module Probability

function get_odd(pr)

    pr / (1.0 - pr)

end

function ge(od)

    od / (1.0 + od)

end

function get_logistic(nu)

    ge(exp(nu))

end

end
