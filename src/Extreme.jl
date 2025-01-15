module Extreme

function ge(ua::Integer, ue)

    if ua * 0.5 <= ue

        collect(1:ua)

    else

        vcat(1:ue, (ua - ue + 1):ua)

    end

end

function ge(an_, ue)

    sortperm(an_)[ge(lastindex(an_), ue)]

end

end
