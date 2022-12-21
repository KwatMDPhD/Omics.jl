function list(di, jo = false; ig_ = (r"^\.",), ke_ = ())

    pa_ = []

    for pa in readdir(di, join = jo)

        na = basename(pa)

        if !any(occursin(ig, na) for ig in ig_) &&
           (isempty(ke_) || any(occursin(ke, na) for ke in ke_))

            push!(pa_, pa)

        end

    end

    pa_

end
