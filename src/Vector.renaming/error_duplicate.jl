function error_duplicate(ve)

    if length(ve) != length(unique(ve))

        error("Vector has 1<= duplicate.")

    end

end
