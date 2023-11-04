using Test: @test

using Nucleus

# ---- #

for (na_, an___) in ((
    ["Row", "Column 1", "Column 2", "Column 3"],
    ([1, 2, 3], ['A', 'B', 'C'], ['A', 'B', 'B'], ['C', 'C', 'C']),
),)

    Nucleus.FeatureXSample.summarize(na_, an___)

end

# ---- #

@test Nucleus.Error.@is Nucleus.FeatureXSample.match(1:2, 3:5, [1 2], [3 4 5])

# ---- #

#disable_logging(Info)

# ---- #

for (co1_, co2_, ro_x_co1_x_an, ro_x_co2_x_an, re) in (
    (1:1, 1:2, [1;;], [1 2], (1:1, [1;;], [1;;])),
    (1:2, 1:2, [1 2], [1 2], (1:2, [1 2], [1 2])),
    (1:3, 2:4, [1 2 3], [2 3 4], (2:3, [2 3], [2 3])),
)

    @test Nucleus.FeatureXSample.match(co1_, co2_, ro_x_co1_x_an, ro_x_co2_x_an) == re

    # 277.354 ns (14 allocations: 1.38 KiB)
    # 287.865 ns (14 allocations: 1.41 KiB)
    # 317.308 ns (14 allocations: 1.41 KiB)
    #@btime Nucleus.FeatureXSample.match($co1_, $co2_, $ro_x_co1_x_an, $ro_x_co2_x_an)

end

# ---- #

#disable_logging(Debug)

# ---- #

const FE_ = (id -> "Feature $id").([1, 1, 2, 3, 2, 3, 4])

# ---- #

const SA_ = ["Sample 1"]

# ---- #

const FEU_ = unique(FE_)

# ---- #

const FE2U_ = replace.(FEU_, "Feature" => "New Feature")

# ---- #

@test Nucleus.FeatureXSample.transform(
    Nucleus.TE,
    FE_,
    SA_,
    [-1.0; 1; 0; -2; 2; 8; 7;;];
    fe_fe2 = Dict(zip(FEU_, FE2U_)),
    fu = Nucleus.FeatureXSample.median,
    ty = Float64,
    lo = true,
    naf = "FF",
    nas = "SS",
    nan = "NN",
) == (FE2U_, [0.0; 1; 2; 3;;])

# ---- #

for fi in ("ff_x_ss_x_nn.html", "ffssnn.html", "ffssnn_plus1_log2.html")

    @test isfile(joinpath(Nucleus.TE, fi))

end
