module TableAccess

using CodecZlib
using CSV
using DataFrames
using Mmap
using XLSX

include("read.jl")

include("read_gz.jl")

include("read_xlsx.jl")

include("write.jl")

end
