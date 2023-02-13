function read(gc)

    CSV_read(gc, DataFrame; header = 3, delim = '\t')[!, Not("Description")]

end
