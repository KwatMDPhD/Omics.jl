function remove_common_prefix(st_)

    pr = BioLab.Vector.get_common_start(st_)

    n = length(pr)

    [st[(n + 1):end] for st in st_]

end
