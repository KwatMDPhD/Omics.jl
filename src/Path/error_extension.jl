function error_extension(pa, ex)

    pae = splitext(pa)[2]

    if pae != ex

        error(pae)

    end

    return nothing

end
