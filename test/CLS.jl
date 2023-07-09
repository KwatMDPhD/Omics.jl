using Test

using BioLab

# ---- #

DA = joinpath(BioLab.DA, "CLS")

# ---- #

@test readdir(DA) == ["CCLE_mRNA_20Q2_no_haem_phen.cls", "GSE76137.cls", "LPS_phen.cls"]

# ---- #

for (na, ta, nu_) in (
    (
        "CCLE_mRNA_20Q2_no_haem_phen.cls",
        "HER2",
        [1.087973, -1.358492, -1.178614, -0.77898, 0.157222, 1.168224, -0.360195, 0.608629],
    ),
    ("GSE76137.cls", "Proliferating_Arrested", [1, 2, 1, 2, 1, 2]),
    ("LPS_phen.cls", "CNTRL_LPS", [1, 1, 1, 2, 2, 2]),
)

    da = BioLab.CLS.read(joinpath(DA, na))

    @test da[!, "Target"] == [ta]

    @test collect(da[1, string.("Sample ", eachindex(nu_))]) == nu_

end
