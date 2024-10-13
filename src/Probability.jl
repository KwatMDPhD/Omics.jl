module Probability

function get_odd(pr)

    pr / (1 - pr)

end

function get_probability(lo)

    od = exp2(lo)

    od / (1 + od)

end

end
