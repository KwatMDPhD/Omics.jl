function error_extension(pa::String, ex::String)::Nothing

    if splitext(pa)[2] != ex

        error("path does not have extension ", ex)

    end

    return nothing

end
