function remove_common_prefix(st_)

    pr = OnePiece.Vector.get_common_start(st_)

    n_ch = length(pr)

    [st[(n_ch + 1):end] for st in st_]

end
