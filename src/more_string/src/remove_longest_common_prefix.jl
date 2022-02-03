function remove_longest_common_prefix(st_::Vector{String})::Vector{String}

    n_ch = length(get_longest_common_prefix(st_))

    if 0 < n_ch

        st_ = [st[(n_ch+1):end] for st in st_]

    end

    return st_

end
