using CodecZlib: GzipDecompressor, transcode
using CSV: read as CSV_read
using DataFrames: DataFrame
using Mmap: mmap


function read_gz(pa::String)::DataFrame

    return CSV_read(transcode(GzipDecompressor, mmap(pa)), DataFrame)

end

export read_gz
