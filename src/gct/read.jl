function read(pa)

    select(DataFrame(CSV.File(pa, header = 3, delim = "\t")), Not("Description"))

end
