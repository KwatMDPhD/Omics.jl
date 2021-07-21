using CSV: read
using CodecZlib: GzipDecompressor, transcode
using DataFrames: DataFrame
using Mmap: mmap


function read_table_gz(pa::String)::DataFrame

    return read(transcode(GzipDecompressor, mmap(pa)), DataFrame)

end

export read_table_gz
