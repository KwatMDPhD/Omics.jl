using CSV: read
using CodecZlib: GzipDecompressor, transcode
using DataFrames: DataFrame
using Mmap: mmap


function read_table_gz(pa::String; s::String = "")::DataFrame

    return DataFrame(read(transcode(GzipDecompressor, mmap(pa))))

end

export read_table_gz
