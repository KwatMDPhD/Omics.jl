module File

using CSV: read, write

using CodecZlib: GzipDecompressor, transcode

using DataFrames: DataFrame, insertcols!

using JSON: parsefile, print

using Mmap: mmap

using OrderedCollections: OrderedDict

using TOML: parsefile as toparsefile

using XLSX: readtable

function read_dictionary(fi, dicttype = OrderedDict; ke_ar...)

    fi[(end - 4):end] == ".toml" ? toparsefile(fi; ke_ar...) :
    parsefile(fi; dicttype, ke_ar...)

end

function write_dictionary(js, ke_va, id = 2)

    open(js, "w") do io

        print(io, ke_va, id)

    end

    js

end

function read_table(fi; ke_ar...)

    if !isfile(fi)

        error()

    end

    it_ = mmap(fi)

    if fi[(end - 2):end] == ".gz"

        it_ = transcode(GzipDecompressor, it_)

    end

    read(it_, DataFrame; ke_ar...)

end

function read_table(xl, sh; ke_ar...)

    DataFrame(readtable(xl, sh; ke_ar...))

end

function write_table(ts, da)

    write(ts, da; delim = '\t')

end

function tabulate(nr, ro_, co_, ma)

    insertcols!(DataFrame(ma, co_), 1, nr => ro_)

end

end
