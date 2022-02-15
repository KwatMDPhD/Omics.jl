TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using OnePiece

using BenchmarkTools

ve = [-2.0, -1, 0, 1, 2]

in_ = convert(Vector{Bool}, [1, 1, 0, 0, 1])

@btime OnePiece.feature_set_enrichment.sum_1_absolute_and_0_count(ve, in_)

using DataFrames

fe_, sc_, fe1_ = OnePiece.feature_set_enrichment.make_benchmark("myc")

in_ = OnePiece.extension.vector.is_in(fe_, fe1_)

sc_fe_sa = DataFrame(
    "Feature" => fe_,
    "Score" => sc_,
    "Score x 10" => sc_ * 10,
    "Constant" => fill(0.8, length(fe_)),
)

se_fe_ = OnePiece.io.gmt.read(
    joinpath(@__DIR__, "feature_set_enrichment.data", "h.all.v7.1.symbols.gmt"),
)

;

@btime OnePiece.extension.vector.is_in(fe_, fe1_)

@btime OnePiece.feature_set_enrichment.score_set(fe_, sc_, fe1_, in_, pl = false)

@btime OnePiece.feature_set_enrichment.score_set(fe_, sc_, fe1_, pl = false)

@btime OnePiece.feature_set_enrichment.score_set(fe_, sc_, se_fe_)

@btime OnePiece.feature_set_enrichment.score_set(sc_fe_sa, se_fe_)

@btime OnePiece.feature_set_enrichment.score_set_new(fe_, sc_, fe1_, pl = false)

@btime OnePiece.feature_set_enrichment.score_set_new(fe_, sc_, se_fe_)

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed ", TE, ".")

end
