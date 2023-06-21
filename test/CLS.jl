using DataFrames: DataFrame

include("environment.jl")

# ---- #

da = joinpath(BioLab.DA, "CLS")

for (na, ta, nu_) in (
    ("CCLE_mRNA_20Q2_no_haem_phen.cls", "HER2", []),
    ("GSE76137.cls", "Proliferating vs Arrested", [1, 2, 1, 2, 1, 2]),
    ("LPS_phen.cls", "CNTRL vs LPS", [1, 1, 1, 2, 2, 2]),
)

    cl = BioLab.CLS.read(joinpath(da, na))

    @test cl[!, "Target"] == [ta]

    if !isempty(nu_)

        @test collect(cl[1, ["Sample $id" for id in 1:length(nu_)]]) == nu_

    end

end
