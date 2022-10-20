module Table

using CodecZlib: GzipDecompressor, transcode

using CSV: read as CSV_read, write as CSV_write

using DataFrames: DataFrame

using Mmap: mmap

using XLSX: readtable

include("../_include.jl")

@_include()

end
