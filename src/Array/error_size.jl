function error_size(ar_)

    if length(unique(size(ar) for ar in ar_)) != 1

        error("Sizes mismatch.")

    end

end
