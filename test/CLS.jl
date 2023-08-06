using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "CLS")

# ---- #

@test BioLab.Path.read(DA) == ["CCLE_mRNA_20Q2_no_haem_phen.cls", "GSE76137.cls", "LPS_phen.cls"]

# ---- #

for (cl, ta, nu_) in (
    (
        "CCLE_mRNA_20Q2_no_haem_phen.cls",
        "HER2",
        [1.087973, -1.358492, -1.178614, -0.77898, 0.157222, 1.168224, -0.360195, 0.608629],
    ),
    ("GSE76137.cls", "Proliferating_Arrested", [1, 2, 1, 2, 1, 2]),
    ("LPS_phen.cls", "CNTRL_LPS", [1, 1, 1, 2, 2, 2]),
)

    cl = joinpath(DA, cl)

    da = BioLab.CLS.read(cl)

    @test size(da, 1) == 1

    @test all(co -> eltype(co) != Any, eachcol(da))

    @test da[1, "Target"] == ta

    @test collect(da[1, string.("Sample ", eachindex(nu_))]) == nu_

    # 388.875 μs (6235 allocations: 530.48 KiB)
    # 10.750 μs (99 allocations: 7.71 KiB)
    # 10.459 μs (99 allocations: 7.66 KiB)
    #@btime BioLab.CLS.read($cl)

end
