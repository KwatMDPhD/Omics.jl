using CSV: read as csv_read
using CodecZlib: GzipDecompressor, transcode
using DataFrames: DataFrame
using Mmap: mmap


function read_gz(pa::String)::DataFrame

    return csv_read(transcode(GzipDecompressor, mmap(pa)), DataFrame)

end

export read_gz
