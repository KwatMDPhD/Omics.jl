function error_extension(pa, ex)

    if splitext(pa)[2] != ex

        error()

    end

    nothing

end
