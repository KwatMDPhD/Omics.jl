function remove_longest_common_prefix(st_)

    pr = OnePiece.vector.get_longest_common_prefix(st_...)

    if pr === nothing

        pr = []

    end

    n_ch = length(pr)

    [st[(n_ch + 1):end] for st in st_]

end
