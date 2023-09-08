using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "CLS")

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

    target_x_sample_x_number = BioLab.CLS.read(cl)

    @test size(target_x_sample_x_number, 1) == 1

    @test all(co -> eltype(co) != Any, eachcol(target_x_sample_x_number))

    @test target_x_sample_x_number[1, "Target"] == ta

    @test collect(target_x_sample_x_number[1, ["Sample $id" for id in eachindex(nu_)]]) == nu_

    # 385.500 μs (6234 allocations: 530.46 KiB)
    # 10.666 μs (98 allocations: 7.70 KiB)
    # 10.417 μs (98 allocations: 7.64 KiB)
    #@btime BioLab.CLS.read($cl)

end
