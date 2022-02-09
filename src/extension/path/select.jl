function select(di; ig_ = [r"^\."], ke_ = [], jo = true)

    pa_ = Vector{AbstractString}()

    for pa in readdir(di; join = jo)

        na = basename(pa)

        if !any(occursin(ig, na) for ig in ig_) &&
           (0 == length(ke_) || any(occursin(ke, na) for ke in ke_))

            push!(pa_, pa)

        end

    end

    return pa_

end
