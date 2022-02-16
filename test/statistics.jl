# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "statistics.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
fr_ = [0.0, 0.001, 0.025, 0.05, 0.5, 0.95, 0.975, 0.999, 1]

for cu in fr_

    println("-"^99)

    println(cu)

    println(OnePiece.statistics.get_z_score(cu))

end

for co in fr_

    println("-"^99)

    println(co)

    println(OnePiece.statistics.get_confidence_interval(co))

end

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
