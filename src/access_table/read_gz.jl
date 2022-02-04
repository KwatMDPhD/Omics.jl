function read_gz(pa::String)::DataFrame

    return CSV.read(transcode(GzipDecompressor, Mmap.mmap(pa)), DataFrame)

end
