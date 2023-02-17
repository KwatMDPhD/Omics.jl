module Table

using CodecZlib: GzipDecompressor, transcode

using CSV: read as _read, write as _write

using DataFrames: DataFrame

using Mmap: mmap

using XLSX: readtable

using ..BioLab

BioLab.@include

end
