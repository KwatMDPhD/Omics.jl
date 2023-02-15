function remove_common_prefix(st_)

    n = length(BioLab.Vector.get_common_start(st_))

    [st[(n + 1):end] for st in st_]

end
