function write_txt(pa::String, se_ge_::Dict{String,Vector{String}})::Nothing

    if !endswith(pa, ".txt")

        error(pa, " is not .txt.")

    end

    open(pa, "w") do io

        for (se, ge_) in se_ge_

            write(io, string("-"^80, "\n"))

            write(io, string(se, " (", length(ge_), "):\n"))

            for ge in ge_

                write(io, string("  ", ge, "\n"))

            end

        end

    end

    return nothing

end
