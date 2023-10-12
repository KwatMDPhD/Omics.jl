using Test: @test

using BioLab

# ---- #

const DA = joinpath(BioLab._DA, "Gene")

# ---- #

@test BioLab.Path.read(DA) == ["ensembl.tsv.gz", "uniprot.tsv.gz"]

# ---- #

function is_missing_string(da)

    all(co -> eltype(co) <: Union{Missing, AbstractString}, eachcol(da))

end

# ---- #

function has_bad(da)

    any(co -> any(BioLab.String.is_bad, skipmissing(co)), eachcol(da))

end

# ---- #

const EN = BioLab.Gene.read_ensemble()

# ---- #

@test size(EN) === (591229, 10)

# ---- #

@test is_missing_string(EN)

# ---- #

@test !has_bad(EN)

# ---- #

const UN = BioLab.Gene.read_uniprot()

# ---- #

@test size(UN) === (20398, 7)

# ---- #

@test is_missing_string(UN)

# ---- #

@test !has_bad(UN)

# ---- #

@test allunique(UN[!, 2])

# ---- #

const EN_GE = BioLab.Gene.map_ensembl(EN)

# ---- #

@test length(EN_GE) === 788360

# ---- #

for (ke, va) in (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test EN_GE[ke] === va

end

# ---- #

# 2.275 s (36735645 allocations: 2.17 GiB)
@btime BioLab.Gene.map_ensembl($EN);

# ---- #

const PR_IO_AN = BioLab.Gene.map_uniprot(UN)

# ---- #

@test length(PR_IO_AN) === 20398

# ---- #

@test PR_IO_AN["CD8A"]["Gene Names"] == ["CD8A", "MAL"]

# ---- #

# 56.019 ms (1632064 allocations: 94.68 MiB)
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

const FEG_ = FE_[.!ismissing.(FE_)]

# ---- #

# [ Info: Renamed 2784600 / 2784600.
BioLab.Gene.rename!(FEG_, EN_GE)

# ---- #

disable_logging(Info)

# ---- #

# 45.327 ms (0 allocations: 0 bytes)
@btime BioLab.Gene.rename!($FEG_, $EN_GE);
