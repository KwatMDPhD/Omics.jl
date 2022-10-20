function error_duplicate(ar)

    if length(ar) != length(unique(ar))

        error("Array has duplicates.")

    end

end
