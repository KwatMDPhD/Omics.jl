module Probability

function get_odd(Pr)

    Pr / (1 - Pr)

end

function get_probability(lo)

    od = exp2(lo)

    od / (1 + od)

end

end
