module Entropy

function ge(pr::Real)

    -pr * log2(pr)

end

# TODO: Consider deleting
function ge(jo)

    en = 0.0

    for pr in jo

        if !iszero(pr)

            en += ge(pr)

        end

    end

    en

end

function ge(ea, jo)

    sum(pr_ -> ge(sum(pr_)), ea(jo))

end

end
