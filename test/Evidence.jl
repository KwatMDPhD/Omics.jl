using Test: @test

using Nucleus

# ---- #

using DataFrames: completecases, disallowmissing!

using GLM: fitted

using Random: seed!

# ---- #

for (id, ta_, f1_, re) in (
    (1, [0, 0, 0, 1, 1, 1], [0, 0, 0, 1, 1, 1], 17.56606848519685),
    (2, [1, 1, 1, 0, 0, 0], [1, 1, 1, 0, 0, 0], 17.56606848519685),
    (3, [0, 1, 0, 1, 0, 1], [0, 1, 0, 1, 0, 1], 17.56606848519685),
    (4, [0, 0, 0, 1, 1, 1], [1, 1, 1, 0, 0, 0], 17.566068485196848),
    (5, [1, 1, 1, 0, 0, 0], [0, 0, 0, 1, 1, 1], 17.56606848519685),
    (6, [0, 1, 0, 1, 0, 1], [1, 0, 1, 0, 1, 0], 17.56606848519685),
)

    ge = Nucleus.Evidence.fit(ta_, f1_)

    @test isapprox(fitted(ge), ta_; rtol = 1e-7)

    @test Nucleus.Evidence.get_evidence(ge, f1_) === re

    # 22.041 μs (209 allocations: 13.89 KiB)
    # 4.929 μs (68 allocations: 3.11 KiB)
    # 22.166 μs (209 allocations: 13.89 KiB)
    # 4.917 μs (68 allocations: 3.11 KiB)
    # 22.000 μs (209 allocations: 13.89 KiB)
    # 4.934 μs (68 allocations: 3.11 KiB)
    # 21.958 μs (209 allocations: 13.89 KiB)
    # 4.935 μs (68 allocations: 3.11 KiB)
    # 22.250 μs (209 allocations: 13.89 KiB)
    # 4.946 μs (68 allocations: 3.11 KiB)
    # 22.208 μs (209 allocations: 13.89 KiB)
    # 4.946 μs (68 allocations: 3.11 KiB)

    #@btime Nucleus.Evidence.fit($ta_, $f1_)

    #@btime Nucleus.Evidence.get_evidence($ge, $f1_)

    Nucleus.Evidence.plot(
        joinpath(Nucleus.TE, "$id.html"),
        "Sample",
        ["_$id" for id in eachindex(ta_)],
        "Target",
        ta_,
        "Feature",
        f1_,
        ge;
        marker_size = 40,
    )

end

# ---- #

seed!()

# ---- #

for (id, ta_, f1_) in (
    ("01 1:100", vcat(fill(0, 50), fill(1, 50)), collect(1:100)),
    ("01 randn", vcat(fill(0, 50), fill(1, 50)), randn(100)),
    ("ra10", rand((0, 1), 10), randn(10)),
    ("ra100", rand((0, 1), 100), randn(100)),
    ("ra1000", rand((0, 1), 1000), randn(1000)),
)

    Nucleus.Evidence.plot(
        joinpath(Nucleus.TE, "$id.html"),
        "Sample",
        ["_$id" for id in eachindex(ta_)],
        "Target",
        ta_,
        "Feature",
        f1_,
        Nucleus.Evidence.fit(ta_, f1_);
    )

    # 67.709 μs (245 allocations: 30.38 KiB)
    # 20.375 μs (154 allocations: 24.24 KiB)
    # 12.667 μs (154 allocations: 10.77 KiB)
    # 21.292 μs (154 allocations: 24.24 KiB)
    # 112.250 μs (155 allocations: 152.20 KiB)
    #@btime Nucleus.Evidence.fit($ta_, $f1_)

end

# ---- #

da = Nucleus.DataFrame.read(
    joinpath(Nucleus._DA, "DataFrame", "titanic.tsv");
    select = ["name", "survived", "sex", "age", "fare", "pclass"],
    missingstring = ["NA"],
)

# ---- #

da = disallowmissing!(da[completecases(da), :])

# ---- #

ns = "Passenger"

# ---- #

sa_ = ["$(da[id, "name"]) ($id)" for id in axes(da, 1)]

# ---- #

nt = "Survival"

# ---- #

ta_ = da[!, "survived"]

# ---- #

nf_ = ["Sex", "Age", "Fare", "Class"]

# ---- #

fs = Matrix{Float64}(undef, lastindex(nf_), lastindex(sa_))

# ---- #

fs[1, :] = replace(da[!, "sex"], "female" => 0, "male" => 1)

# ---- #

fs[2, :] = da[!, "age"]

# ---- #

fs[3, :] = da[!, "fare"]

# ---- #

fs[4, :] = [4 - parse(Int, da[id, "pclass"][1]) for id in eachindex(sa_)]

# ---- #

ts = Nucleus.Match.make(
    Nucleus.TE,
    Nucleus.Information.get_information_coefficient,
    ns,
    sa_,
    nt,
    ta_,
    "Feature",
    nf_,
    fs;
)

# ---- #

for (id, re) in
    enumerate([1.1681195763601897, 0.08630585757607466, 0.3886782595762168, 0.6055654277469712])

    ge = Nucleus.Evidence.fit(ta_, fs[id, :])

    Nucleus.Evidence.plot(
        joinpath(Nucleus.TE, "$(nf_[id]).html"),
        ns,
        sa_,
        nt,
        ta_,
        nf_[id],
        fs[id, :],
        ge;
    )

    @test Nucleus.Evidence.get_evidence(ge, fs[id, :]) === re

end
