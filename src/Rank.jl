module Rank

function get_extreme(ua::Integer, ue)

    if 0.5 * ua <= ue

        collect(1:ua)

    else

        vcat(collect(1:ue), collect((ua - ue + 1):ua))

    end

end

function get_extreme(an_, ue)

    sortperm(an_)[get_extreme(lastindex(an_), ue)]

end

end
