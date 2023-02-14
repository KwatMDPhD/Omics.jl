function error_duplicate(ar)

    if length(ar) != length(unique(ar))

        error()

    end

    nothing

end
