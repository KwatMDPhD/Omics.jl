using Test: @test

using Nucleus

# ---- #

const DA = joinpath(Nucleus._DA, "Gene")

# ---- #

@test Nucleus.Path.read(DA) == ["ensembl.tsv.gz", "uniprot.tsv.gz"]

# ---- #

function test_data_frame(da, si)

    @test size(da) === si

    for co in eachcol(da)

        @test eltype(co) <: Union{Missing, AbstractString}

        @test !any(Nucleus.String.is_bad, skipmissing(co))

    end

end

# ---- #

const EN = Nucleus.Gene.read_ensemble()

# ---- #

test_data_frame(EN, (591229, 10))

# ---- #

const UN = Nucleus.Gene.read_uniprot()

# ---- #

test_data_frame(UN, (20398, 7))

# ---- #

@test allunique(UN[!, 2])

# ---- #

const EN_GE = Nucleus.Gene.map_ensembl(EN)

# ---- #

@test length(EN_GE) === 788360

# ---- #

for (en, ge) in (("GPI-214", "GPI"), ("ENST00000303227", "GLOD5"), ("ENST00000592956.1", "SYT5"))

    @test EN_GE[en] === ge

end

# ---- #

# 2.155 s (36735645 allocations: 2.17 GiB)
#@btime Nucleus.Gene.map_ensembl(EN);

# ---- #

const PR_IO_AN = Nucleus.Gene.map_uniprot(UN)

# ---- #

@test length(PR_IO_AN) === 20398

# ---- #

@test PR_IO_AN["CD8A"]["Gene Names"] == ["CD8A", "MAL"]

# ---- #

# 55.693 ms (1632064 allocations: 94.68 MiB)
#@btime Nucleus.Gene.map_uniprot(UN);

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

Nucleus.Gene.rename!(FEG_, EN_GE)

# ---- #

#disable_logging(Info)

# ---- #

# 45.191 ms (0 allocations: 0 bytes)
#@btime Nucleus.Gene.rename!(FEG_, EN_GE);
