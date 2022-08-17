module table

using CodecZlib

using CSV

using DataFrames

using Mmap

using XLSX

include("../include_neighbor.jl")

include_neighbor(@__FILE__)

end
