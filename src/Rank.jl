module Rank

function get_extreme(n::Integer, n_ex)

    if 0.5 * n <= n_ex

        collect(1:n)

    else

        vcat(collect(1:n_ex), collect((n - n_ex + 1):n))

    end

end

function get_extreme(an_, n_ex)

    sortperm(an_)[get_extreme(lastindex(an_), n_ex)]

end

end
