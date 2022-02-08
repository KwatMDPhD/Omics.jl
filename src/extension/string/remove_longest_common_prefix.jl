function remove_longest_common_prefix(st_)

    pr = get_longest_common_prefix(st_)

    if pr !== nothing 

        n_ch = length(pr)

        return [st[(n_ch+1):end] for st in st_]

    end

end
