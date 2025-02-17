module Extreme

function ge(u1::Integer, u2)

    u1 * 0.5 <= u2 ? collect(1:u1) : vcat(1:u2, (u1 - u2 + 1):u1)

end

function ge(an_, um)

    sortperm(an_)[ge(lastindex(an_), um)]

end

end
