using Aqua: test_all, test_ambiguities

using Test: @test

using BioLab

# ---- #

test_all(BioLab; ambiguities = false)

test_ambiguities(BioLab)

# ---- #

# ----------------------------------------------------------------------------------------------- #

function read_filter(di)

    filter!(!startswith('_'), readdir(di))

end

# ---- #

const SR = joinpath(dirname(@__DIR__), "src")

const MO_ = read_filter(SR)

# ---- #

for mo in MO_

    @test chop(mo; tail = 3) == split(readline(joinpath(SR, mo)))[2]

end

# ---- #

@test isconst(BioLab, :_DA)

@test basename(BioLab._DA) == "data"

@test readdir(BioLab._DA) ==
      ["CLS", "Dict", "FeatureSetEnrichment", "GCT", "GMT", "Gene", "Plot", "SingleCell", "Table"]

# ---- #

@test isconst(BioLab, :TE)

@test contains(
    basename(BioLab.TE),
    r"^BioLab[\d]{4}_[\d]{1}_[\d]{2}_[\d]{2}_[\d]{2}_[\d]{2}_[\d]{3}$",
)

@test isempty(readdir(BioLab.TE))

# ---- #

@test BioLab.@is_error error("This is an error message.")

# ---- #

const TE_ = read_filter(@__DIR__)

# ---- #

@test symdiff(MO_, TE_) == ["BioLab.jl", "runtests.jl"]

# ---- #

for te in TE_

    if te != "runtests.jl"

        @info "Testing $te"

        run(`julia --project $te`)

    end

end
