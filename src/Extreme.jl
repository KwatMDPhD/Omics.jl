module Extreme

function get(ua::Integer, ue)

    if ua * 0.5 <= ue

        collect(1:ua)

    else

        vcat(1:ue, (ua - ue + 1):ua)

    end

end

function get(an_, ue)

    sortperm(an_)[get(lastindex(an_), ue)]

end

end
