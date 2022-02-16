function select(di; ig_ = [r"^\."], ke_ = [], jo = true)

    pa_ = Vector{AbstractString}()

    for pa in readdir(di, join = jo)

        na = basename(pa)

        if !any(occursin.(ig_, na)) && (isempty(ke_) || any(occursin.(ke_, na)))

            push!(pa_, pa)

        end

    end

    pa_

end
