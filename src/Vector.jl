module Vector

function get_extreme(n::Int, n_ex)

    if n / 2 < n_ex

        collect(1:n)

    else

        vcat(collect(1:n_ex), collect((n - n_ex + 1):n))

    end

end

function get_extreme(an_::AbstractVector, n_ex)

    sortperm(an_)[get_extreme(length(an_), n_ex)]

end

function get_extreme(fl_::AbstractVector{Float64}, n_ex)

    sortperm(fl_)[get_extreme(length(fl_) - sum(isnan, fl_), n_ex)]

end

end
