module Probability

function get_odd(pr)

    pr / (1 - pr)

end

function ge(od)

    od / (1 + od)
end

function ge(ea, jo)

    map(sum, ea(jo))

end

end
