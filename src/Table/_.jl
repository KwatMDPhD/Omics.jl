module Table

using CodecZlib: GzipDecompressor, transcode

using CSV: read as CSV_read, write as CSV_write

using DataFrames: DataFrame

using Mmap: mmap

using XLSX: readtable

using ..BioLab

BioLab.@include

end
