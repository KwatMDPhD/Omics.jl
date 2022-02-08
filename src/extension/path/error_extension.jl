function error_extension(pa, ex)

    exp = splitext(pa)[2]

    if exp != ex

        error(exp, " is not ", ex)

    end

end
