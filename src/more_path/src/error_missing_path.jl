function error_missing_path(ro::String, pa_::Vector{String})::Nothing

    mi_ = Vector{String}()

    for pa in pa_

        pa = joinpath(ro, pa)

        if !ispath(pa)

            push!(mi_, pa)

        end

    end

    if 0 < length(mi_)

        error("missing ", mi_)

    end

    return nothing

end
