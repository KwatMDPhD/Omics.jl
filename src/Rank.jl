module Rank

function get_extreme(ua::Integer, ue)

    if ua * 0.5 <= ue

        collect(1:ua)

    else

        vcat(1:ue, (ua - ue + 1):ua)

    end

end

function get_extreme(an_, ue)

    sortperm(an_)[get_extreme(lastindex(an_), ue)]

end

end
