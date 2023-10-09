using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "CLS")

# ---- #

@test BioLab.Path.read(DA) == ["CCLE_mRNA_20Q2_no_haem_phen.cls", "GSE76137.cls", "LPS_phen.cls"]

# ---- #

for (cl, ta, re) in (
    (
        "CCLE_mRNA_20Q2_no_haem_phen.cls",
        "HER2",
        [1.087973, -1.358492, -1.178614, -0.77898, 0.157222, 1.168224, -0.360195, 0.608629],
    ),
    ("GSE76137.cls", "Proliferating_Arrested", [1, 2, 1, 2, 1, 2]),
    ("LPS_phen.cls", "CNTRL_LPS", [1, 1, 1, 2, 2, 2]),
)

    dcl = joinpath(DA, cl)

    nar, ro_, co_, fe_x_sa_x_nu = BioLab.DataFrame.separate(BioLab.CLS.read(dcl))

    @test nar === "Target"

    @test ro_ == [ta]

    @test all(startswith("Sample "), co_)

    @test eltype(fe_x_sa_x_nu) === eltype(re)

    @test fe_x_sa_x_nu[1, eachindex(re)] == re

    # 409.500 μs (6235 allocations: 530.47 KiB)
    # 9.875 μs (99 allocations: 7.73 KiB)
    # 9.750 μs (99 allocations: 7.67 KiB)
    #@btime BioLab.CLS.read($dcl)

end
