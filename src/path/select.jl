function select(
    di::String;
    ig_::Vector{Regex} = [r"^\."],
    ke_::Vector{Regex} = Vector{Regex}([]),
    jo::Bool = true,
)::Vector{String}

    pa_ = Vector{String}()

    for pa in readdir(di; join = jo)

        na = splitdir(pa)[2]

        if !any(occursin(ig, na) for ig in ig_) &&
           (0 == length(ke_) || any(occursin(ke, na) for ke in ke_))

            push!(pa_, pa)

        end

    end

    return pa_

end

export select
