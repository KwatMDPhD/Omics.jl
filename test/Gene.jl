using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Gene")

# ---- #

@test BioLab.Path.read(DA) == ["ensembl.tsv.gz", "uniprot.tsv.gz"]

# ---- #

function is_type(da)

    all(eltype(co) <: Union{Missing, AbstractString} for co in eachcol(da))

end

# ---- #

const EN = BioLab.Gene.read_ensemble()

# ---- #

@test size(EN) === (591229, 10)

# ---- #

@test is_type(EN)

# ---- #

const UN = BioLab.Gene.read_uniprot()

# ---- #

@test size(UN) === (20398, 7)

# ---- #

@test is_type(UN)

# ---- #

const EN_NA = BioLab.Gene.map_ensembl(EN)

# ---- #

@test length(EN_NA) === 788360

# ---- #

for (ke, va) in (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test EN_NA[ke] === va

end

# ---- #

# 2.646 s (40077165 allocations: 2.27 GiB)
@btime BioLab.Gene.map_ensembl($EN);

# ---- #

const PR_DI = BioLab.Gene.map_uniprot(UN)

# ---- #

@test length(PR_DI) === 20398

# ---- #

@test PR_DI["CD8A"]["Gene Names"] == ["CD8A", "MAL"]

# ---- #

# 61.372 ms (1632064 allocations: 94.68 MiB)
@btime BioLab.Gene.map_uniprot($UN);

# ---- #

const FE_ = vec(
    Matrix(
        EN[
            .!ismissing.(EN[!, "Gene name"]),
            [
                "Transcript stable ID version",
                "Transcript stable ID",
                "Transcript name",
                "Gene stable ID version",
                "Gene stable ID",
            ],
        ],
    ),
)

# ---- #

const FEG_ = FE_[.!BioLab.Bad.is.(FE_)]

# ---- #

# [ Info: Renamed 2784600 / 2784600.
BioLab.Gene.rename!(FEG_, EN_NA)

# ---- #

disable_logging(Info)

# ---- #

# 203.208 ms (2784600 allocations: 66.17 MiB)
@btime BioLab.Gene.rename!($FEG_, $EN_NA);
