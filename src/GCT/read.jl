function read(gc)

    return CSV_read(gc, DataFrame; header = 3, delim = '\t')[!, Not("Description")]

end
