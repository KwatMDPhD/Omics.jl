TE = joinpath(tempdir(), "Kwat.test", "")

if isdir(TE)

    rm(TE; recursive = true)

end

mkdir(TE)

println("Made ", TE)

using Revise
using BenchmarkTools

using Kwat

rm(TE; recursive = true)

println("Removed ", TE)
