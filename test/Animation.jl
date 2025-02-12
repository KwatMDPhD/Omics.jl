using Test: @test

using Omics

# ---- #

Omics.Animation.writ(
    joinpath(tempdir(), "_.gif"),
    (pkgdir(Omics, "data", "Animation", "$id.png") for id in 1:2),
)
