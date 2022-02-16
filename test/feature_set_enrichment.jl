# ----------------------------------------------------------------------------------------------- #
TE = joinpath(tempdir(), "OnePiece.test")

if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end

mkdir(TE)

println("Made $TE.")

# ----------------------------------------------------------------------------------------------- #
using OnePiece

# ----------------------------------------------------------------------------------------------- #
OnePiece.feature_set_enrichment.get_probability_and_cumulate([1, 4])

OnePiece.feature_set_enrichment.sum_1_absolute_and_0_count(
    [-2.0, -1, 0, 1, 2],
    convert(Vector{Bool}, [1, 1, 0, 0, 1]),
)

try

    OnePiece.feature_set_enrichment.make_benchmark("card 12K")

catch er

    er

end

OnePiece.feature_set_enrichment.make_benchmark("card A2K")

OnePiece.feature_set_enrichment.make_benchmark("random 3 2")

OnePiece.feature_set_enrichment.make_benchmark("random 4 2")

fe_, sc_, fe1_ = OnePiece.feature_set_enrichment.make_benchmark("myc")

println(length(fe_))

println(length(sc_))

println(length(fe1_))

fe_, sc_, fe1_ = OnePiece.feature_set_enrichment.make_benchmark("card AK")

;

OnePiece.feature_set_enrichment.score_set(fe_, sc_, fe1_, ou = joinpath(TE, "mountain.html"))

OnePiece.feature_set_enrichment.score_set_new(
    fe_,
    sc_,
    fe1_,
    ou = joinpath(TE, "mountain_new.html"),
)

using DataFrames

fe_, sc_, fe1_ = OnePiece.feature_set_enrichment.make_benchmark("myc")

in_ = OnePiece.vector.is_in(fe_, fe1_)

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

OnePiece.feature_set_enrichment.score_set(fe_, sc_, fe1_, in_)

OnePiece.feature_set_enrichment.score_set(fe_, sc_, fe1_)

OnePiece.feature_set_enrichment.score_set(fe_, sc_, se_fe_)

OnePiece.feature_set_enrichment.score_set(sc_fe_sa, se_fe_)

OnePiece.feature_set_enrichment.score_set_new(fe_, sc_, fe1_)

OnePiece.feature_set_enrichment.score_set_new(fe_, sc_, se_fe_)

OnePiece.feature_set_enrichment.try_method(fe_, sc_, fe1_, plp = false)

# ----------------------------------------------------------------------------------------------- #
if isdir(TE)

    rm(TE, recursive = true)

    println("Removed $TE.")

end
