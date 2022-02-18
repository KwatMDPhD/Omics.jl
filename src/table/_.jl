module table

using CodecZlib
using CSV
using DataFrames
using Mmap
using XLSX

include("read.jl")

include("write.jl")

end
