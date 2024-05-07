using Test: @test

using Nucleus

# ---- #

using GLM: fitted, predict

# ---- #

for (ta_, f1_) in (
    ([0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1]),
    ([1, 1, 1, 0, 0, 0], [1, 1, 1, 0, 0, 0]),
    ([0, 0, 0, 1, 1, 1], [1, 1, 1, 0, 0, 0]),
    ([1, 1, 1, 0, 0, 0], [0, 0, 0, 1, 1, 1]),
    ([0, 1, 0, 1, 0, 1], [0, 1, 0, 1, 0, 1]),
    ([0, 1, 0, 1, 0, 1], [1, 0, 1, 0, 1, 0]),
)

    ge = Nucleus.Evidence.fit(ta_, f1_)

    @test isapprox(fitted(ge), ta_; rtol = 1e-7)

    Nucleus.Evidence.plot(
        "",
        "Sample",
        ["_$id" for id in eachindex(ta_)],
        "Target",
        ta_,
        "Feature",
        f1_,
        ge;
        marker_size = 40,
    )

    # 22.542 μs (209 allocations: 13.89 KiB)
    # 22.625 μs (209 allocations: 13.89 KiB)
    # 22.708 μs (209 allocations: 13.89 KiB)
    # 22.583 μs (209 allocations: 13.89 KiB)
    # 22.750 μs (209 allocations: 13.89 KiB)
    # 22.708 μs (209 allocations: 13.89 KiB)
    #@btime Nucleus.Evidence.fit($ta_, $f1_)

end

# ---- #

for (ta_, f1_) in ((rand((0, 1), 100), randn(100)),)

    ge = Nucleus.Evidence.fit(ta_, f1_)

    Nucleus.Evidence.plot(
        "",
        "Sample",
        ["_$id" for id in eachindex(ta_)],
        "Target",
        ta_,
        "Feature",
        f1_,
        ge;
    )

    #@btime Nucleus.Evidence.fit($ta_, $f1_)

end

# ---- #

da = Nucleus.DataFrame.read(joinpath(Nucleus._DA, "DataFrame", "titanic.tsv"))

# ---- #

ns = "Passenger"

sa_ = ["$(da[id, "name"]) ($id)" for id in axes(da, 1)]

# ---- #

nt = "Survival"

ta_ = da[!, "survived"]

# ---- #

nf_ = ["Sex", "Age", "Fare"]

fs = Matrix{Float64}(undef, lastindex(nf_), lastindex(ta_))

fs[1, :] = replace(da[!, "sex"], "female" => 0, "male" => 1)

# TODO: Remove "NA"s.

fs[2, :] = parse.(Float64, replace!(da[!, "age"], "NA" => "-1"))

fs[3, :] = parse.(Float64, replace!(da[!, "fare"], "NA" => "-1"))

# ---- #

ts = Nucleus.Match.make(
    Nucleus.TE,
    Nucleus.Information.get_information_coefficient,
    ns,
    sa_,
    "Survived",
    ta_,
    "Feature",
    nf_,
    fs;
    layout = Dict("title" => Dict("text" => "Match Panel")),
)

# ---- #

id = 3

Nucleus.Evidence.plot(
    "",
    ns,
    sa_,
    nt,
    ta_,
    nf_[id],
    fs[id, :],
    Nucleus.Evidence.fit(ta_, fs[id, :]);
)
